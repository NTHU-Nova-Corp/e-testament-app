# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Executors
      # Create Heir operation
      class GetActiveExecutor
        def initialize(config)
          @config = config
        end

        # rubocop:disable Metrics/AbcSize
        def call(current_account:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .get("#{@config.API_URL}/executors")

          raise Exceptions::ApiServerError if response.code != 200

          response_data = JSON.parse(response.to_s)['data']
          executor_info = response_data.nil? ? nil : response_data['attributes']
          status = response_data.nil? ? nil : Models::Executor.new.active
          Models::Executor.new(executor_info, status)
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
