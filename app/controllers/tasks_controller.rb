class TasksController < ApplicationController
    before_action :authenticate_user
    before_action :fetch_task, only: [:update, :show, :destroy]

    # Function is Used to Create Tasks.
    def create
        task = @current_user.tasks.new(task_params)
        if task.save
            render_success(TaskSerializer.new(task))
        else
            render_error(task.errors.full_messages.first)
        end
    end

    # Function to Update Tasks.
    def update
        if @task.present? && @task.update(task_params)
            render_success(TaskSerializer.new(@task))
        else
            error_msg = @task.present? ? @task.errors.full_messages.first : "No Record Found."
            render_error(error_msg)
        end
    end

    # Function to Show Tasks.
    def show
        if @task.present?
            render_success(TaskSerializer.new(@task))
        else
            render_error("No Record Found.")
        end
    end

    # Function to List Tasks according to status.
    def index
        tasks = @current_user.tasks_list(params[:for_status], params[:search_text], params[:sort_by], params[:sort_direction])
        tasks = ActiveModel::SerializableResource.new(tasks, each_serializer: TaskSerializer).as_json
        render_success(tasks)
    end

    # Function to delete the Tasks.
    def destroy
        if @task.present? && @task.delete
            render_success({})
        else
            error_msg = @task.present? ? @task.errors.full_messages.first : "No Record Found."
            render_error(error_msg)
        end
    end

    private

    # Function to fetch task for show, update and delete fucntion.
    def fetch_task
        @task = @current_user.tasks.find_by_id(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :description, :status)
    end
end
