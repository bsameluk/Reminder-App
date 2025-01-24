class InitReminderSyncJob
  include Sidekiq::Job

  attr_accessor :reminder, :reminder_history

  def perform(reminder_id)
    @reminder = Reminder.find(reminder_id)
    @reminder_history = ReminderHistory.where(reminder_id: reminder_id,
                                              status: ReminderHistory::Statuses::DONE,
                                              scheduled_at: @reminder.scheduled_at)
    return if @reminder_history.exists?

    _cancel_active_broadcast_reminder

    @reminder_history = ReminderHistory.find_or_create_by(
      scheduled_at: @reminder.scheduled_at,
      status: ReminderHistory::Statuses::PENDING,
      reminder_id: @reminder.id
    )

    begin
      _init_broadcast_reminder
    rescue => e
      @reminder_history.update(status: ReminderHistory::Statuses::FAILED)
    end
  end

  private

  def _cancel_active_broadcast_reminder
    ReminderHistory
      .active
      .where(reminder_id: @reminder.id)
      .pluck(:job_id, :id)
      .each do |job_id, id|
        Sidekiq::ScheduledSet.new.find_job(job_id)&.delete
        ReminderHistory.find(id).update(status: ReminderHistory::Statuses::CANCELED, job_id: nil)
    end
  end

  def _init_broadcast_reminder
    job_id = BroadcastReminderJob.perform_at(@reminder_history.scheduled_at, @reminder_history.id)
    @reminder_history.update(job_id: job_id)
  end

end
