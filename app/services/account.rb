# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    # Returns an authenticated user, or nil
    class Account
      # Error for accounts that cannot be created
      class InvalidAccount < StandardError
        def message = 'This account can no longer be created: please start again'
      end

      class VerificationError < StandardError; end
      class UnauthorizedError < StandardError; end
      class ApiServerError < StandardError; end

      def initialize(config)
        @config = config
      end

      def signin(username:, password:)
        response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                             json: { username:, password: })

        raise(UnauthorizedError) if response.code == 403
        raise(ApiServerError) if response.code != 200

        account_info = JSON.parse(response.to_s)['attributes']

        { account: account_info['account']['data']['attributes'],
          auth_token: account_info['auth_token'] }
      rescue HTTP::ConnectionError
        raise ApiServerError
      end

      # registration_data
      # - username
      # - email
      # - verification_url
      def send_email_confirmation(registration_data)
        registration_token = SecureMessage.encrypt(registration_data)
        registration_data['verification_url'] =
          "#{@config.APP_URL}/auth/signup/#{registration_token}"

        response = HTTP.post("#{@config.API_URL}/auth/register",
                             json: registration_data)
        raise(VerificationError) unless response.code == 202

        JSON.parse(response.to_s)
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def signup(username:, password:, first_name:, last_name:, email:)
        response = HTTP.post("#{@config.API_URL}/accounts",
                             json: { username:, password:, first_name:, last_name:, email: })

        raise InvalidAccount unless response.code == 201
      end
    end
  end
end
