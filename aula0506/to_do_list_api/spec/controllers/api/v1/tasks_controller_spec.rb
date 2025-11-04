require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:json_response) { JSON.parse(response.body) }

  describe "GET #index" do
    context "when there are no tasks" do
      it "returns an empty array" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq([])
      end
    end

    context "when there are tasks" do
      let!(:tasks) { create_list(:task, 3) }
      let!(:cancelled_task) { create(:cancelled_task) }

      it "returns all tasks including soft deleted ones" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(4)
      end

      it "returns tasks with required attributes" do
        get :index
        task = json_response.first
        %w[id title description status delivery_date created_at updated_at].each do |attr|
          expect(task).to have_key(attr)
        end
      end

      it "includes soft deleted tasks" do
        get :index
        cancelled = json_response.find { |task| task["id"] == cancelled_task.id }
        expect(cancelled["status"]).to eq("cancelled")
        expect(cancelled["deleted_at"]).to be_present
      end
    end
  end

  describe "GET #show" do
    let!(:task) { create(:task) }

    it "returns the specific task" do
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(task.id)
      expect(json_response["title"]).to eq(task.title)
    end

    it "raises error for non-existent task" do
      expect {
        get :show, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { attributes_for(:task) }

    context "with valid parameters" do
      it "creates a new task and returns it" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response["title"]).to eq(valid_attributes[:title])
        expect(json_response["status"]).to eq(valid_attributes[:status])
      end

      it "assigns default status when not provided" do
        post :create, params: { task: valid_attributes.except(:status) }
        expect(json_response["status"]).to eq("initial")
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: "", description: "", status: "" } }

      it "returns validation errors" do
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key("title")
        expect(json_response).to have_key("description")
      end
    end

    it "raises error for missing task parameter" do
      expect {
        post :create, params: { title: "Test" }
      }.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe "PATCH #update" do
    let!(:task) { create(:task) }
    let(:new_attributes) { { title: "Updated Task", status: "in_progress" } }

    context "with valid parameters" do
      it "updates and returns the task" do
        patch :update, params: { id: task.id, task: new_attributes }
        
        expect(response).to have_http_status(:ok)
        expect(json_response["title"]).to eq("Updated Task")
        expect(json_response["status"]).to eq("in_progress")
        
        task.reload
        expect(task.title).to eq("Updated Task")
      end
    end

    context "with invalid parameters" do
      it "returns validation errors" do
        patch :update, params: { id: task.id, task: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to have_key("title")
      end
    end

    it "raises error for non-existent task" do
      expect {
        patch :update, params: { id: 999999, task: new_attributes }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "DELETE #destroy" do
    let!(:task) { create(:task) }

    it "soft deletes the task" do
      delete :destroy, params: { id: task.id }
      
      expect(response).to have_http_status(:ok)
      expect(json_response["status"]).to eq("cancelled")
      expect(Date.parse(json_response["deleted_at"])).to eq(Date.today)
      
      task.reload
      expect(task.deleted_at).to eq(Date.today)
      expect(task.status).to eq("cancelled")
    end

    it "does not remove task from database" do
      expect {
        delete :destroy, params: { id: task.id }
      }.not_to change(Task, :count)
    end

    it "raises error for non-existent task" do
      expect {
        delete :destroy, params: { id: 999999 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end