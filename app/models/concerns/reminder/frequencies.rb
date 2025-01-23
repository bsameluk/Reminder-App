module Reminder::Frequencies
  extend ActiveSupport::Concern

  ONE_TIME = 'One-Time'.freeze
  EACH_DAY = 'Each day'.freeze
  EACH_WEEK = 'Each week'.freeze
  EACH_MONTH = 'Each month'.freeze

  DICT = {
    one_time: ONE_TIME,
    each_day: EACH_DAY,
    each_week: EACH_WEEK,
    each_month: EACH_MONTH,
  }.freeze
  ALL = [ONE_TIME, EACH_DAY, EACH_WEEK, EACH_MONTH].freeze

  def frequency
    self.class.frequencies[super]
  end

  def frequency_was
    self.class.frequencies[super]
  end
end
