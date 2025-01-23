# == Schema Information
#
# Table name: reminder_histories
#
#  id           :bigint           not null, primary key
#  scheduled_at :datetime         not null
#  status       :enum             default("Pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  reminder_id  :bigint           not null
#
# Indexes
#
#  index_reminder_histories_on_reminder_id  (reminder_id)
#
# Foreign Keys
#
#  fk_rails_...  (reminder_id => reminders.id)
#
require "test_helper"

class ReminderHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
