class BroadcastReminderJob
  include Sidekiq::Job

  def perform(reminder_id)
    @reminder = Reminder.find(reminder_id)
    @reminder_history = ReminderHistory.where(reminder_id: reminder_id,
                                              status: ReminderHistory::Statuses::DONE,
                                              scheduled_at: @reminder.scheduled_at)
    return if @reminder_history.exists?
    return unless @reminder.is_due?

    @reminder_history = ReminderHistory.find_or_create_by(scheduled_at: @reminder.scheduled_at,
                                               status: ReminderHistory::Statuses::PENDING,
                                               reminder_id: @reminder.id)

    begin
      ActionCable.server.broadcast("public", {
        notification: {
          subject:      "#{@reminder.title}, #{@reminder.price} #{@reminder.currency}",
          body:         @reminder.description,
          scheduled_at: @reminder.formatted_scheduled_at,
          reminder_id:  @reminder.id
        }
      })
    rescue => e
      @reminder_history.update(status: ReminderHistory::Statuses::FAILED)
      raise e
    end
  end
end
