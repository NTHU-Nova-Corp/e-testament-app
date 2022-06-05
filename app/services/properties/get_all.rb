# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      # Get all properties related with an account
      class GetAll
        def initialize(config)
          @config = config
        end

        def call(current_account:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/properties")
          raise Exceptions::ApiServerError if response.code != 200

          Models::Properties.new(response.code == 200 ? response.parse['data'] : [])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
