# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module PropertyHeirs
      # Get all heirs related with a particular property
      class GetHeirsRelatedWithProperty
        def initialize(config)
          @config = config
        end

        def call(current_account:, property_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/properties/#{property_id}/heirs")
          raise Exceptions::ApiServerError if response.code != 200

          Models::PropertyHeirs.new(response.code == 200 ? response.parse['data'] : [])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
