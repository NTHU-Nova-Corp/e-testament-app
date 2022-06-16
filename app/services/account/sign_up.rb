# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Accounts
      # Sign up operation
      class SignUp
        def initialize(config)
          @config = config
        end

        # rubocop:disable Metrics/MethodLength
        def call(registration_token:, first_name:, last_name:, password:)
          new_account = SecureMessage.decrypt(registration_token)
          username = new_account['username']
          email = new_account['email']
          response = HTTP.post("#{@config.API_URL}/accounts",
                               json: SignedMessage.sign({ username:, password:, first_name:, last_name:, email: }))

          response_data = JSON.parse(response.to_s)
          raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
          raise Exceptions::ApiServerError if response.code != 201

        rescue HTTP::ConnectionError
          raise ApiServerError
        end

        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
