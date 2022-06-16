# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testators
      module Documents
        # Get all Documents related with a property related with an account
        class Get
          def initialize(config)
            @config = config
          end

          def call(current_account:, testator_id:, property_id:, document_id:)
            # api/v1/testators/:testator_id/testament/properties/:property_id/documents
            response = HTTP.auth("Bearer #{current_account.auth_token}")
                           .get("#{@config.API_URL}/testators/#{testator_id}/testament/properties/#{property_id}/documents/#{document_id}")

            response_data = JSON.parse(response.to_s)
            raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
            raise Exceptions::ApiServerError if response.code != 200

            Models::Document.new(response.parse['data'])
          rescue HTTP::ConnectionError
            raise Exceptions::ApiServerError
          end
        end
      end
    end
  end
end
