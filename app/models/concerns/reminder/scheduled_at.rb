module Reminder::ScheduledAt
  extend ActiveSupport::Concern

  # @return [DateTime]
  def min_next_scheduled_at
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

  # @param [DateTime] date_time
  # @return [DateTime]
  def next_by_frequency(date_time = scheduled_at)
    case frequency
      when Reminder::Frequencies::ONE_TIME
        date_time
      when Reminder::Frequencies::EACH_2_MINUTES
        date_time + 2.minutes
      when Reminder::Frequencies::EACH_5_MINUTES
        date_time + 5.minutes
      when Reminder::Frequencies::EACH_DAY
        date_time + 1.day
      when Reminder::Frequencies::EACH_WEEK
        date_time + 1.week
      when Reminder::Frequencies::EACH_MONTH
        date_time + 1.month
    end
  end

  # @return [DateTime]
  def next_scheduled_at
    next_by_frequency >= min_next_scheduled_at ? next_by_frequency : min_next_scheduled_at
  end

end
