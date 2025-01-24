# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BroadcastReminderJob, type: :job do
  describe '#perform' do
    let!(:reminder) do
      Reminder.create!(
        title: "Test reminder",
        scheduled_at: 1.day.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::EACH_DAY,
        timezone: "UTC",
        description: "Test description"
      )
    end

    let!(:reminder_history) do
      ReminderHistory.create!(
        reminder: reminder,
        scheduled_at: Time.current,
        status: ReminderHistory::Statuses::PENDING
      )
    end

    it 'enqueues job with sidekiq' do
      expect {
        described_class.perform_async(reminder_history.id)
      }.to change(described_class.jobs, :size).by(1)
    end

    context 'when history is due and pending' do
      before do
        allow(ActionCable.server).to receive(:broadcast)
      end

      it 'broadcasts notification via ActionCable' do
        expect(ActionCable.server).to receive(:broadcast).with(
          "public",
          {
            notification: {
              subject: "Test reminder, 99.99 USD",
              body: "Test description",
              reminder_history_id: reminder_history.id
            }
          }
        )

        described_class.new.perform(reminder_history.id)
      end

      it 'marks history as done' do
        described_class.new.perform(reminder_history.id)
        reminder_history.reload

        expect(reminder_history.status).to eq(ReminderHistory::Statuses::DONE)
        expect(reminder_history.job_id).to be_nil
      end

      context 'when reminder is recurring' do
        let!(:reminder) do
          Reminder.create!(
            title: "Test reminder",
            scheduled_at: 1.day.from_now,
            price: 99.99,
            currency: "USD",
            frequency: Reminder::Frequencies::EACH_DAY,
            timezone: "UTC",
            description: "Test description"
          )
        end

        it 'updates reminder scheduled_at' do
          described_class.new.perform(reminder_history.id)
          _old_next_scheduled_at = reminder.next_scheduled_at
          reminder.reload

          expect(reminder.scheduled_at).to eq(_old_next_scheduled_at)
        end
      end

      context 'when reminder is one-time' do
        let!(:reminder) do
          Reminder.create!(
            title: "Test reminder",
            scheduled_at: 1.day.from_now,
            price: 99.99,
            currency: "USD",
            frequency: Reminder::Frequencies::ONE_TIME,
            timezone: "UTC",
            description: "Test description"
          )
        end

        it 'does not update reminder scheduled_at' do
          original_scheduled_at = reminder.scheduled_at
          described_class.new.perform(reminder_history.id)
          reminder.reload

          expect(reminder.scheduled_at).to eq(original_scheduled_at)
        end
      end
    end

    context 'when history is not pending' do
      before do
        reminder_history.update!(status: ReminderHistory::Statuses::DONE)
      end

      it 'does not broadcast notification' do
        expect(ActionCable.server).not_to receive(:broadcast)
        described_class.new.perform(reminder_history.id)
      end
    end

    context 'when history is not due yet' do
      let!(:reminder_history) do
        ReminderHistory.create!(
          reminder: reminder,
          scheduled_at: 1.day.from_now,
          status: ReminderHistory::Statuses::PENDING
        )
      end

      it 'does not broadcast notification' do
        expect(ActionCable.server).not_to receive(:broadcast)
        described_class.new.perform(reminder_history.id)
      end
    end

    context 'when broadcast fails' do
      before do
        allow(ActionCable.server).to receive(:broadcast).and_raise(StandardError)
      end

      it 'marks history as failed' do
        expect {
          described_class.new.perform(reminder_history.id)
        }.to raise_error(StandardError)

        reminder_history.reload
        expect(reminder_history.status).to eq(ReminderHistory::Statuses::FAILED)
      end
    end

    context 'when history not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          described_class.new.perform(0)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
