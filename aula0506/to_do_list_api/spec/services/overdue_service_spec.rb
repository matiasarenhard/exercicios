require 'rails_helper'

RSpec.describe OverdueService, type: :service do
  describe '#call' do
    subject(:service_call) { described_class.new.call }

    context 'when there are no overdue tasks' do
      it 'returns success with count 0' do
        result = service_call

        expect(result).to eq(success: true, count: 0)
      end
    end

    context 'when updated_count is exactly 1' do
      let!(:single_overdue_task) { create(:task, status: :in_progress, delivery_date: 1.day.ago) }

      it 'returns count 1 with singular message' do
        result = service_call

        expect(result[:success]).to be(true)
        expect(result[:count]).to eq(1)
        expect(result[:message]).to eq("1 task updated to overdue status")
      end
    end

    context 'when there are overdue tasks' do
      let!(:overdue_task1) { create(:task, status: :in_progress, delivery_date: 1.week.ago) }
      let!(:overdue_task2) { create(:task, status: :initial, delivery_date: 3.days.ago) }
      let!(:future_task)   { create(:task, status: :initial, delivery_date: 2.days.from_now) }

      it 'updates only overdue tasks to overdue status' do
        result = service_call

        expect(result[:success]).to be(true)
        expect(result[:count]).to eq(2)
        expect(result[:message]).to eq("2 tasks updated to overdue status")
      end
    end
  end
end
