require 'rails_helper'

RSpec.describe OverdueJob, type: :job do
  describe '#perform' do
    it 'executes the OverdueService and applies its side effects' do
      task = create(:task, status: "in_progress", delivery_date: 1.week.ago)
      described_class.perform_now
      expect(Task.last.status).to eq("overdue")
    end
  end

  describe 'queue' do
    it 'is queued on the default queue' do
      expect(described_class.queue_name).to eq('default')
    end

    it 'enqueues the job' do
      expect {
        described_class.perform_later
      }.to have_enqueued_job(described_class).on_queue('default')
    end
  end
end