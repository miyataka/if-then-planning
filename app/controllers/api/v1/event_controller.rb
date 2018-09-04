class Api::V1::EventController < ApplicationController
    include GoogleCalendarAuthorize

    def index
        @events = fetchEvents().items

        #render json: @events, status: :ok
        render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
    end
end
