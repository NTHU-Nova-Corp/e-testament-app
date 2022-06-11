# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      module Documents
        # Create a document
        class Create
          def initialize(config)
            @config = config
          end

          # rubocop:disable Metrics/ParameterLists
          def call(current_account:, property_id:,
                   file_name:, description:, content:, type:)
            body = { file_name:, type:, description:, content: }
            response = HTTP.auth("Bearer #{current_account.auth_token}")
                           .post("#{@config.API_URL}/properties/#{property_id}/documents", json: body)

            response_data = JSON.parse(response.to_s)
            raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
            raise Exceptions::ApiServerError if response.code != 201

            response
          rescue HTTP::ConnectionError
            raise Exceptions::ApiServerError
          end
          # rubocop:enable Metrics/ParameterLists
        end
      end
    end
  end
end
