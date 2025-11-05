require "rails_helper"

RSpec.describe Task, type: :model do
  describe "scopes" do
    let!(:active_task) { create(:task, deleted_at: nil) }
    let!(:inactive_task) { create(:task, deleted_at: Date.today) }

    describe ".active" do
      it "returns only active tasks" do
        expect(Task.active).to include(active_task)
        expect(Task.active).not_to include(inactive_task)
      end
    end

    describe ".inactive" do
      it "returns only inactive tasks" do
        expect(Task.inactive).to include(inactive_task)
        expect(Task.inactive).not_to include(active_task)
      end
    end

    describe ".overdue" do
      let!(:overdue_task) { create(:task, delivery_date: 3.days.ago, status: :in_progress, deleted_at: nil) }
      let!(:future_task)  { create(:task, delivery_date: 3.days.from_now, status: :in_progress, deleted_at: nil) }
      let!(:completed_task) { create(:task, delivery_date: 5.days.ago, status: :completed, deleted_at: nil) }
      let!(:cancelled_task) { create(:task, delivery_date: 5.days.ago, status: :cancelled, deleted_at: nil) }
      let!(:inactive_task)  { create(:task, delivery_date: 5.days.ago, status: :in_progress, deleted_at: Date.today) }

      it "returns only active tasks with past delivery_date that are not completed or cancelled" do
        result = Task.overdue

        expect(result).to include(overdue_task)
        expect(result).not_to include(future_task)
        expect(result).not_to include(completed_task)
        expect(result).not_to include(cancelled_task)
        expect(result).not_to include(inactive_task)
      end
    end
  end

  describe "#destroy" do
    let!(:task) { create(:task, status: :in_progress, deleted_at: nil) }

    it "sets deleted_at and changes status to cancelled" do
      expect {
        task.destroy
      }.to change { task.reload.status }.from("in_progress").to("cancelled")
       .and change { task.reload.deleted_at }.from(nil).to(Date.today)
    end

    it "does not actually remove the record from the database" do
      task.destroy
      expect(Task.find_by(id: task.id)).to be_present
    end
  end
end
