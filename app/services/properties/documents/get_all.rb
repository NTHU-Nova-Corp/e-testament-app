# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      module Documents
        # Get all Documents related with a property related with an account
        class GetAll
          def initialize(config)
            @config = config
          end

          def call(current_account:, property_id:)
            response = HTTP.auth("Bearer #{current_account.auth_token}")
                           .get("#{@config.API_URL}/properties/#{property_id}/documents")
            raise Exceptions::ApiServerError if response.code != 200

            response.parse['data'].map { |m| m['attributes'] }
          rescue HTTP::ConnectionError
            raise Exceptions::ApiServerError
          end
        end
      end
    end
  end
end
