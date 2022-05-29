# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Heirs
      # Sign in operation
      class Create
        def initialize(config)
          @config = config
        end

        def call(current_account, first_name:, last_name:, email:, relation_id:)
          body = { first_name:, last_name:, email:, relation_id: }
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/heirs", json: body)
          raise Exceptions::ApiServerError if response.code != 201

          response
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
