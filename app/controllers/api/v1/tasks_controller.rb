class Api::V1::TasksController < ApplicationController

    # GET /api/v1/tasks
    def index
        @tasks = Task.order('updated_at DESC')

        render json: @tasks, status: :ok
        #render :index, status: :ok
    end

    # POST /api/v1/tasks
    def create
        @task = Task.new(task_params)

        if @task.save
            render :show, status: :created
        else
            render json: @task.error, status: :unprocessable_entity
        end
    end

    # PUT/PATCH /api/v1/tasks/[:id]
    def update
        @task = Task.find_by(id: task_params[:id])

        @task.name = task_params[:name]
        @task.due = task_params[:due]
        @task.is_done = task_params[:is_done]

        if @task.save
            render :show, status: :ok
        else
            render json: @task.error, status: :unprocessable_entity
        end
    end

    # DELETE /api/v1/tasks/[:id]
    def destroy
        @task = Task.find_by(id: params[:id])

        if @task.destroy
        else
            render json: @task.error, status: :unprocessable_entity
        end
    end

    private
        def task_params
            params.fetch(:task, {}).permit(
                :id, :name, :calendar_id, :order, :event_id, :due, :is_done
            )
        end
end
