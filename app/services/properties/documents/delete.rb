# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      module Documents
        # Deletes a document
        class Delete
          def initialize(config)
            @config = config
          end

          def call(current_account:, property_id:, document_id:)
            response = HTTP.auth("Bearer #{current_account.auth_token}")
                           .post("#{@config.API_URL}/properties/#{property_id}/documents/#{document_id}/delete")

            response_data = JSON.parse(response.to_s)
            raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
            raise Exceptions::ApiServerError if response.code != 201

            response
          rescue HTTP::ConnectionError
            raise Exceptions::ApiServerError
          end
        end
      end
    end
  end
end
