# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Executors
      # Create Heir operation
      class GetExecutor
        def initialize(config)
          @config = config
        end

        def call(current_account:)
          executor = Services::Executors::GetActiveExecutor.new(@config).call(current_account:)
          executor = Services::Executors::GetSentRequest.new(@config).call(current_account:) if executor.unassigned?
          executor
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
