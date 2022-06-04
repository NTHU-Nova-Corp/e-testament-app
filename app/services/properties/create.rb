# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      # Create Property operation
      class Create
        def initialize(config)
          @config = config
        end

        def call(current_account:, name:, property_type_id:, description:)
          body = { name:, property_type_id:, description: }
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/properties", json: body)
          raise Exceptions::ApiServerError if response.code != 201

          response
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
