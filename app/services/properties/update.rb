# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      # Updates a specific property
      class Update
        def initialize(config)
          @config = config
        end

        def call(current_account:, id:, name:, property_type_id:, description:)
          body = { name:, property_type_id:, description: }
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/properties/#{id}", json: body)
          raise Exceptions::ApiServerError if response.code != 200

          response
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
