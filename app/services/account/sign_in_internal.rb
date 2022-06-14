# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Accounts
      # Sign in operation
      class SignInInternal
        def initialize(config, session)
          @config = config
          @session = session
        end

        def call(username:, password:)
          credentials = { username: username, password: password }

          response = HTTP.post("#{@config.API_URL}/auth/authenticate", json: SignedMessage.sign(credentials))
          Services::Accounts::SignIn.new(@config, @session).call(response:)
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
