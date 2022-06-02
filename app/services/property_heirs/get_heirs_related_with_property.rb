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

        def call(property_id)
          response = HTTP.get("#{@config.API_URL}/properties/#{property_id}/heirs")
          raise Exceptions::ApiServerError if response.code != 200

          JSON.parse(response).map { |m| m['data']['attributes'] }
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end