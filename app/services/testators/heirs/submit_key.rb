# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testators
      module Heirs
        # Submits the key for a particular heir
        class SubmitKey
          def initialize(config)
            @config = config
          end

          def call(heir_id:, heir_key:)
            body = { heir_id:, heir_key: }
            response = HTTP.post("#{@config.API_URL}/testators/submit-key", json: body)

            response_data = JSON.parse(response.to_s)
            raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
            raise Exceptions::ApiServerError if response.code != 200

            response
          rescue HTTP::ConnectionError
            raise Exceptions::ApiServerError
          end
        end
      end
    end
  end
end
