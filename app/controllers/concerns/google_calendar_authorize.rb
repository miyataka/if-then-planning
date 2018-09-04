require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'client_secret.json'.freeze
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

module GoogleCalendarAuthorize
    extend ActiveSupport::Concern

    def authorize
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      # TODO rewrite this logic
      if credentials.nil?
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts 'Open the following URL in the browser and enter the ' \
             "resulting code after authorization:\n" + url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end
      credentials
    end

    def initialize
        @service = Google::Apis::CalendarV3::CalendarService.new
        @service.client_options.application_name = APPLICATION_NAME
        @service.authorization = authorize
    end

    def fetchEvents
        calendar_id = 'primary'
        @service.list_events(calendar_id,
                            max_results: 10,
                            single_events: true,
                            order_by: 'startTime',
                            time_min: Time.now.iso8601)
    end
end
