# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id           :bigint           not null, primary key
#  currency     :string(3)        not null
#  description  :text
#  frequency    :enum             not null
#  price        :decimal(14, 2)   not null
#  scheduled_at :datetime         not null
#  timezone     :string           not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Reminder < ApplicationRecord

  enum frequency: Frequencies::DICT, _prefix: :frequency

  # concerns
  include Frequencies
  include ScheduledAt


  # associations
  has_many :reminder_histories, dependent: :destroy

  # validates
  validates :title,         presence: true
  validates :scheduled_at,  presence: true, comparison: { greater_than_or_equal_to: ->(record) { record.min_scheduled_at },
                                                          message: 'must be in the future' }
  validates :price,         presence: true
  validates :currency,  presence: true, length: { is: 3 }, inclusion: { in: Currencies::ALL }
  validates :frequency, presence: true, inclusion: { in: Frequencies::ALL }
  validates :timezone,  presence: true

  after_commit :broadcast_reminder , on:  :create

  private

  def broadcast_reminder
    BroadcastReminderJob.perform_at(scheduled_at, id)
  end
end
