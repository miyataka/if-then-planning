class Api::V1::EventController < ApplicationController
    include GoogleCalendarAuthorize

    def index
        # TODO error handle
        @events = fetchEvents().items

        render 'index', status: :ok
    end

    def create
        # TODO error handle
        @event = createEvent(params_create_event)

        render 'show', status: :created
    end

    def update
        # TODO
    end

    def destroy
        @event = deleteEvent(params_event_specify)

        if @event.empty?
            # what is return?
            render json: @event.error, status: :unprocessable_entity
        else
            head :no_content
        end
    end

    private
        def params_create_event
            params.fetch(:event, {}).permit(
                :summary, :start, :end
            )
        end

        def params_event_specify
            params.permit(
                :calender_id, :event_id
            )
        end
end
