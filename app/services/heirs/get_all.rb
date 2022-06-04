# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Heirs
      # Get all heirs related with an account
      class GetAll
        def initialize(config)
          @config = config
        end

        def call(current_account:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/heirs")
          raise Exceptions::ApiServerError if response.code != 200

          response.parse['data'].map { |m| m['data']['attributes'] }
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
