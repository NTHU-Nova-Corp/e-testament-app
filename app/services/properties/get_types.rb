# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      # Gets the list of property types available
      class GetTypes
        def initialize(config)
          @config = config
        end

        def call(current_account:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/property_types")
          raise Exceptions::ApiServerError if response.code != 200

          response.parse['data'].map { |m| m['attributes'] }
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
