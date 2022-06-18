# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testators
      module Documents
        # Get all Documents related with a property related with an account
        class GetAll
          def initialize(config)
            @config = config
          end

          # rubocop:disable Metrics/AbcSize
          def call(current_account:, testator_id:, property_id:)
            uri = "#{@config.API_URL}/testators/#{testator_id}/testament/properties/#{property_id}/documents"
            # api/v1/testators/:testator_id/testament/properties/:property_id/documents
            response = HTTP.auth("Bearer #{current_account.auth_token}").get(uri)

            response_data = JSON.parse(response.to_s)
            raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
            raise Exceptions::ApiServerError if response.code != 200

            puts response.to_s

            Models::Documents.new(response.code == 200 ? response.parse['data'] : [])
          rescue HTTP::ConnectionError
            raise Exceptions::ApiServerError
          end

          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
