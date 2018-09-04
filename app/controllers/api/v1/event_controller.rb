class Api::V1::EventController < ApplicationController
    include GoogleCalendarAuthorize

    def index
        @response = fetchEvents()

        render json: @response.items, status: :ok
    end
end
