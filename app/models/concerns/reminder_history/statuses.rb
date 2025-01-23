module ReminderHistory::Statuses
  extend ActiveSupport::Concern

  PENDING = 'Pending'.freeze
  DONE = 'Done'.freeze
  FAILED = 'Failed'.freeze

  DICT = {
    pending: PENDING,
    done: DONE,
    failed: FAILED
  }.freeze
  ALL = [PENDING, DONE, FAILED].freeze

  def status
    self.class.statuses[super]
  end

  def status_was
    self.class.statuses[super]
  end

end
