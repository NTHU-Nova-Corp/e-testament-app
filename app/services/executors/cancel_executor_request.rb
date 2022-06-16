# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Executors
      # Create Heir operation
      class CancelExecutorRequest
        def initialize(config)
          @config = config
        end

        def call(current_account:, executor_email:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/executors/#{executor_email}/cancel")

          raise Exceptions::ApiServerError if response.code != 200
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
