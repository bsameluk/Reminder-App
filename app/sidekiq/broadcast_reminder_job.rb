class BroadcastReminderJob
  include Sidekiq::Job

  def perform(reminder_history_id)
    @reminder_history = ReminderHistory.find(reminder_history_id)
    return unless @reminder_history.status_pending?
    return unless @reminder_history.is_due?
    @reminder = @reminder_history.reminder

    begin
      _init_action_cable
      @reminder_history.update(status: ReminderHistory::Statuses::DONE, job_id: nil)
      @reminder.update(scheduled_at: @reminder.next_scheduled_at)
    rescue => e
      @reminder_history.update(status: ReminderHistory::Statuses::FAILED)
      raise e
    end
  end

  private

  def _init_action_cable
    ActionCable.server.broadcast("public", {
      notification: {
        subject:      "#{@reminder.title}, #{@reminder.price} #{@reminder.currency}",
        body:         @reminder.description,
        reminder_history_id: @reminder_history.id,
      }
    })
  end
end
