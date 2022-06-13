# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testators
      # Get testator information
      class GetInfo
        def initialize(config)
          @config = config
        end

        def call(current_account:, testator_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/testators/#{testator_id}")
          raise Exceptions::ApiServerError if response.code != 200

          Models::Testator.new(response.code == 200 ? response.parse['data'] : [])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
