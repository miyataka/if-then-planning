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
            render :show, status: :created
        else
            render json: @task.error, status: :unprocessable_entity
        end
    end

    # PUT/PATCH /api/v1/tasks/[:id]
    def update
        # TODO
    end

    # DELETE /api/v1/tasks/[:id]
    def destroy
        # TODO
    end

    private
        def task_params
            params.fetch(:task, {}).permit(
                :name, :calendar_id, :order, :event_id, :due, :is_done
            )
        end
end
