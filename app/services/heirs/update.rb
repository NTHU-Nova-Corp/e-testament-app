# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Heirs
      # Updates a specific heir
      class Update
        def initialize(config)
          @config = config
        end

        # rubocop:disable Metrics/ParameterLists
        def call(current_account:, id:, first_name:, last_name:, email:, relation_id:)
          body = { first_name:, last_name:, email:, relation_id: }
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/heirs/#{id}", json: body)
          raise Exceptions::BadRequestError if response.code != 200

          response
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
        # rubocop:enable Metrics/ParameterLists
      end
    end
  end
end
