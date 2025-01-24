module ReminderHistory::Statuses
  extend ActiveSupport::Concern

  PENDING = 'Pending'.freeze
  DONE = 'Done'.freeze
  FAILED = 'Failed'.freeze
  CANCELED = 'Canceled'.freeze

  DICT = {
    pending: PENDING,
    done: DONE,
    failed: FAILED,
    canceled: CANCELED
  }.freeze
  ALL = [PENDING, DONE, FAILED, CANCELED].freeze

  def status
    self.class.statuses[super]
  end

  def status_was
    self.class.statuses[super]
  end

end
