module Api
  module V1
    class TasksController < ApplicationController
      include Pagy::Backend
      before_action :set_task, only: %i[ show update destroy ]

      def index
        if params[:q].present?
          @q = Task.where.not(status: 5).ransack(
            title_or_description_cont: params[:q],
            delivery_date_eq: params[:delivery_date],
            created_at_eq: params[:created_at]
          )
          @tasks_search = @q.result
        else
          @tasks_search = Task.where.not(status: 5).all
        end
        @pagy, @tasks = pagy(@tasks_search)
        render json: @tasks
      end

      def show
        render json: @task
      end

      def create
        @task = Task.new(task_params)
        if @task.save
          render json: @task, status: :created, location: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @task.update({ deleted_at: Date.today, status: Task.statuses[:cancelled] })
      end

      private

      def set_task
        @task = Task.find(params.require(:id))
      end

      def task_params
        params.require(:task).permit(:title, :description, :status, :delivery_date)
      end
    end
  end
end
