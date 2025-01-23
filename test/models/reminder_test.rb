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
require "test_helper"

class ReminderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
