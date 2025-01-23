module Reminder::ScheduledAt
  extend ActiveSupport::Concern

  # @return [DateTime]
  def min_scheduled_at
    (Time.current + 1.minute).change(sec: 0)
  end

  # @param [String] timezone
  # @return [String]
  def formatted_scheduled_at
    scheduled_at.in_time_zone(timezone).strftime('%d/%m/%Y %H:%M')
  end

  # @return [Boolean]
  def is_due?
    scheduled_at <= Time.current
  end

end
