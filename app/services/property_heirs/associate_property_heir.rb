# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module PropertyHeirs
      # Associates a heir with a property
      class AssociatePropertyHeir
        def initialize(config)
          @config = config
        end

        def call(current_account:, heir_id:, property_id:, percentage:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/properties/#{property_id}/heirs/#{heir_id}", json: { percentage: })

          response_data = JSON.parse(response.to_s)
          raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
          raise Exceptions::ApiServerError if response.code != 200
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
