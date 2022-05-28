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
                               json: { username:, password:, first_name:, last_name:, email: })

          unless response.code == 201
            raise Exceptions::BadRequestError,
                  'This account can no longer be created: please start again'
          end
        rescue HTTP::ConnectionError
          raise ApiServerError
        end
        # rubocop:enabe Metrics/MethodLength
      end
    end
  end
end
