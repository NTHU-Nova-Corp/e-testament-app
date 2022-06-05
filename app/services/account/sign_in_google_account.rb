# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Accounts
      # Returns an authenticated user, or nil
      class SignInGoogleAccount
        def initialize(config, session)
          @config = config
          @session = session
        end

        def call(access_token:)
          response = HTTP.post("#{ENV.fetch('API_URL', nil)}/auth/authenticate-google", json: { access_token: })
          Services::Accounts::SignIn.new(@config, @session).call(response:)
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
