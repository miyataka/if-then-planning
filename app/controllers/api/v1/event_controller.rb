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

    private
        def params_create_event
            params.fetch(:event, {}).permit(
                :summary, :start, :end
            )
        end
end
