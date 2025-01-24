# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReminderHistory, type: :model do
  describe 'associations' do
    it { should belong_to(:reminder) }
  end

  describe 'validations' do
    it { should validate_presence_of(:scheduled_at) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:reminder_id) }

    it 'defines status enum with correct mappings' do
      expected_mappings = {
        "pending"   => "Pending",
        "done"      => "Done",
        "failed"    => "Failed",
        "canceled"  => "Canceled"
      }

      expect(ReminderHistory.statuses).to eq(expected_mappings)
    end
  end

  describe 'scopes' do
    describe '.active' do
      let!(:pending_history) do
        ReminderHistory.create!(
          reminder: reminder,
          scheduled_at: 1.day.from_now,
          status: ReminderHistory::Statuses::PENDING
        )
      end

      let!(:completed_history) do
        ReminderHistory.create!(
          reminder: reminder,
          scheduled_at: 1.day.from_now,
          status: ReminderHistory::Statuses::DONE
        )
      end

      let(:reminder) do
        Reminder.create!(
          title: "Test reminder",
          scheduled_at: 1.day.from_now,
          price: 99.99,
          currency: "USD",
          frequency: Reminder::Frequencies::EACH_2_MINUTES,
          timezone: "UTC"
        )
      end

      it 'returns only pending histories' do
        expect(ReminderHistory.active).to eq([pending_history])
      end
    end
  end

  describe '#is_due?' do
    let(:reminder) do
      Reminder.create!(
        title: "Test reminder",
        scheduled_at: 1.day.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::ALL.first,
        timezone: "UTC"
      )
    end

    let(:history) do
      ReminderHistory.new(
        reminder: reminder,
        status: ReminderHistory::Statuses::PENDING
      )
    end

    context 'when scheduled_at is in the past' do
      before { history.scheduled_at = 1.hour.ago }

      it 'returns true' do
        expect(history.is_due?).to be true
      end
    end

    context 'when scheduled_at is in the future' do
      before { history.scheduled_at = 1.hour.from_now }

      it 'returns false' do
        expect(history.is_due?).to be false
      end
    end
  end
end
