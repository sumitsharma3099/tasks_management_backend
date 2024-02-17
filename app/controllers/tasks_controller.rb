class TasksController < ApplicationController
    before_action :authenticate_user
    before_action :fetch_task, only: [:update, :show, :destroy]
    before_action :set_params, only: [ :index ]

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
        order_by_str = params[:sort_by] + " " + params[:sort_direction]
        tasks = @current_user.tasks_list(params[:for_status], params[:search_text])
        pagination_hash = set_pagination_hash tasks
        tasks = ActiveModel::SerializableResource.new(tasks.paginate(page: params[:page], per_page: params[:per_page]).order(order_by_str), each_serializer: TaskSerializer).as_json
        data = {tasks: tasks, pagination_hash: pagination_hash}
        render_success(data)
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

    def set_params
        params[:page] = 1 if params[:page].blank? || params[:page].nil?
        params[:per_page] = 5 if params[:per_page].blank? || params[:per_page].nil?
        params[:sort_by] = "created_at" if params[:sort_by].blank? || params[:sort_by].nil?
        params[:sort_direction] = "ASC" if params[:sort_direction].blank? || params[:sort_direction].nil?
    end

    def set_pagination_hash tasks
        total_records = tasks.count
        page = params[:page].to_i
        per_page = params[:per_page].to_i
        total_pages = total_records/per_page
        total_pages = total_records%per_page == 0 ? total_pages : (total_pages + 1)
        {total_records: total_records, page: page, per_page: per_page, total_pages: total_pages}
    end

    def task_params
        params.require(:task).permit(:title, :description, :status)
    end
end
