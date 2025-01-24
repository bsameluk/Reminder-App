# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InitReminderSyncJob, type: :job do
  describe '#perform' do
    let!(:reminder) do
      Reminder.create!(
        title: "Test reminder",
        scheduled_at: 1.day.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::EACH_DAY,
        timezone: "UTC"
      )
    end

    it 'enqueues job with sidekiq' do
      expect {
        described_class.perform_async(reminder.id)
      }.to change(described_class.jobs, :size).by(1)
    end

    context 'when no completed history exists' do
      it 'creates new reminder history' do
        expect {
          described_class.new.perform(reminder.id)
        }.to change(ReminderHistory, :count).by(1)

        history = ReminderHistory.last
        expect(history.reminder).to eq(reminder)
        expect(history.scheduled_at).to eq(reminder.scheduled_at)
        expect(history.status).to eq(ReminderHistory::Statuses::PENDING)
      end

      it 'schedules broadcast job' do
        expect(BroadcastReminderJob).to receive(:perform_at)
          .with(reminder.scheduled_at, kind_of(Integer))
          .and_return('job_id')

        described_class.new.perform(reminder.id)

        expect(ReminderHistory.last.job_id).to eq('job_id')
      end
    end

    context 'when completed history exists' do
      let!(:completed_history) do
        ReminderHistory.create!(
          reminder: reminder,
          scheduled_at: reminder.scheduled_at,
          status: ReminderHistory::Statuses::DONE
        )
      end

      it 'does not create new history' do
        expect {
          described_class.new.perform(reminder.id)
        }.not_to change(ReminderHistory, :count)
      end

      it 'does not schedule broadcast job' do
        expect(BroadcastReminderJob).not_to receive(:perform_at)
        described_class.new.perform(reminder.id)
      end
    end

    context 'when active histories exist' do
      let!(:active_history) do
        ReminderHistory.create!(
          reminder: reminder,
          scheduled_at: 2.days.from_now,
          status: ReminderHistory::Statuses::PENDING,
          job_id: 'old_job_id'
        )
      end

      let(:scheduled_set) { instance_double(Sidekiq::ScheduledSet) }
      let(:job) { instance_double(Sidekiq::SortedEntry) }

      before do
        allow(Sidekiq::ScheduledSet).to receive(:new).and_return(scheduled_set)
        allow(scheduled_set).to receive(:find_job).with('old_job_id').and_return(job)
        allow(job).to receive(:delete)
      end

      it 'cancels existing active histories' do
        described_class.new.perform(reminder.id)

        active_history.reload
        expect(active_history.status).to eq(ReminderHistory::Statuses::CANCELED)
        expect(active_history.job_id).to be_nil
      end

      it 'deletes scheduled sidekiq job' do
        expect(job).to receive(:delete)
        described_class.new.perform(reminder.id)
      end
    end

    context 'when broadcast job scheduling fails' do
      before do
        allow(BroadcastReminderJob).to receive(:perform_at).and_raise(StandardError)
      end

      it 'marks history as failed' do
        described_class.new.perform(reminder.id)
        expect(ReminderHistory.last.status).to eq(ReminderHistory::Statuses::FAILED)
      end
    end

    context 'when reminder not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          described_class.new.perform(0)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
