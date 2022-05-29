# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Properties
      # Delete Property operation
      class Delete
        def initialize(config)
          @config = config
        end

        def call(current_account, delete_property_id:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/properties/#{delete_property_id}/delete")
          raise Exceptions::ApiServerError if response.code != 200

          response
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
