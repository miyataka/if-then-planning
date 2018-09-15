class Api::V1::TasksController < ApplicationController

    # GET /api/v1/tasks
    def index
        @task = Task.order('updated_at DESC')

        render json: @task, status: :ok
    end

    # POST /api/v1/tasks
    def create
        @task = Task.new(task_params)

        if @task.save
            render json: @task, status: :created
        else
            render json: @task.error, status: :unprocessable_entity
        end
    end

    def update
    end

    def destroy
    end

    private
        def task_params
            params.fetch(:task, {}).permit(
                :summary, :calendar_id, :order, :event_id
            )
        end
end
