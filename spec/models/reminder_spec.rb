# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reminder, type: :model do
  describe 'associations' do
    it { should have_many(:reminder_histories).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:scheduled_at) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:frequency) }
    it { should validate_presence_of(:timezone) }

    it { should validate_length_of(:currency).is_equal_to(3) }
    it { should validate_inclusion_of(:currency).in_array(Currencies::ALL) }

    it 'defines frequency enum with correct mappings' do
      expected_mappings = {
        "one_time"        => "One-Time",
        "each_2_minutes"  => "Each 2 minutes",
        "each_5_minutes"  => "Each 5 minutes",
        "each_day"        => "Each day",
        "each_week"       => "Each week",
        "each_month"      => "Each month"
      }

      expect(Reminder.frequencies).to eq(expected_mappings)
    end
  end

  describe 'callbacks' do
    describe 'after_commit' do
      let!(:reminder) do
        Reminder.create!(
          title: "Test reminder",
          scheduled_at: 1.day.from_now,
          price: 99.99,
          currency: "USD",
          frequency: Reminder::Frequencies::ALL.first,
          timezone: "UTC"
        )
      end

      context 'when scheduled_at is changed' do
        it 'broadcasts reminder' do
          expect(InitReminderSyncJob).to receive(:perform_async).with(reminder.id)
          reminder.update(scheduled_at: 1.day.from_now)
        end
      end

      context 'when scheduled_at is not changed' do
        it 'does not broadcast reminder' do
          expect(InitReminderSyncJob).not_to receive(:perform_async)
          reminder.update(title: 'New Title')
        end
      end
    end
  end

  describe 'scheduled_at validation' do
    let(:reminder) do
      Reminder.new(
        title: "Test reminder",
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::ALL.first,
        timezone: "UTC"
      )
    end

    context 'when scheduled_at is in the past' do
      before { reminder.scheduled_at = 1.day.ago }

      it 'is not valid' do
        expect(reminder).not_to be_valid
        expect(reminder.errors[:scheduled_at]).to include('must be in the future')
      end
    end

    context 'when scheduled_at is in the future' do
      before { reminder.scheduled_at = 1.day.from_now }

      it 'is valid' do
        expect(reminder).to be_valid
      end
    end
  end
end
