# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testators
      # Get testator information
      class GetTestament
        def initialize(config)
          @config = config
        end

        # rubocop:disable Metrics/AbcSize
        def call(current_account:, testator_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/testators/#{testator_id}/testament")

          response_data = JSON.parse(response.to_s)
          raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
          raise Exceptions::ApiServerError if response.code != 200

          Models::PropertiesDistribution.new(response.code == 200 ? response.parse['data'] : [])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
