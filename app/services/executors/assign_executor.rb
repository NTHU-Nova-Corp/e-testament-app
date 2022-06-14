# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Executors
      # Create Heir operation
      class AssignExecutor
        def initialize(config)
          @config = config
        end

        def call(current_account:, assign_email:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/executors")

          raise Exceptions::ApiServerError if response.code != 200

          response_data = JSON.parse(response.to_s)['data']
          Models::Executor.new(response_data.nil? ? nil : response_data['attributes'])
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
