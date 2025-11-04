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
