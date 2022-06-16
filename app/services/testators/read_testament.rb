# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testators
      # Get testator information
      class ReadTestament
        def initialize(config)
          @config = config
        end

        def call(current_account:, testator_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/testators/#{testator_id}/read")

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
