# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      # Get a property information
      class GetInfo
        def initialize(config)
          @config = config
        end

        def call(current_account:, property_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/properties/#{property_id}")
          raise Exceptions::ApiServerError if response.code != 200

          Models::Property.new(response.code == 200 ? response.parse['data'] : [])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
