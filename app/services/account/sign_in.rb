# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Accounts
      # Sign in operation
      class SignIn
        def initialize(config, session)
          @config = config
          @session = session
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def call(username:, password:)
          response = HTTP.post("#{@config.API_URL}/auth/authenticate", json: { username:, password: })

          raise Exceptions::UnauthorizedError if response.code == 403
          raise Exceptions::BadRequestError if response.code == 400
          raise Exceptions::ApiServerError if response.code != 200

          account_info = JSON.parse(response.to_s)['attributes']
          current_account = Models::Account.new(account_info['account']['data']['attributes'],
                                                account_info['auth_token'])

          Models::CurrentSession.new(@session).current_account = current_account
          current_account
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
        # rubocop:enabe Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
