# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testament
      # Get all testators related with an account
      class Get
        def initialize(config)
          @config = config
        end

        # rubocop:disable Metrics/AbcSize
        def call(current_account:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/testaments")

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
