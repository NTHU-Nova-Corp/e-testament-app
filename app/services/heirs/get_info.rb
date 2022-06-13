# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Heirs
      # Get a heir information
      class GetInfo
        def initialize(config)
          @config = config
        end

        def call(current_account:, heir_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/heirs/#{heir_id}")
          raise Exceptions::ApiServerError if response.code != 200

          Models::Heir.new(response.code == 200 ? response.parse['data'] : [])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
