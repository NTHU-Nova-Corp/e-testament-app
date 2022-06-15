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
          credentials = { access_token: }

          response = HTTP.post("#{@config.API_URL}/auth/authenticate-google", json: SignedMessage.sign(credentials))
          Services::Accounts::SignIn.new(@config, @session).call(response:)
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
