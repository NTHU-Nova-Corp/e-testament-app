# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testament
      # Get all testators related with an account
      class MarkAsComplete
        def initialize(config)
          @config = config
        end

        def call(current_account:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/testaments/complete")

          response_data = JSON.parse(response.to_s)
          raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
          raise Exceptions::ApiServerError if response.code != 200
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
