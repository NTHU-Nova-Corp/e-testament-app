# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Utils
      # Get registrationForm
      class GetRegistrationForm
        def initialize(config)
          @config = config
        end

        def call(registration_data:)
          registration_token = SecureMessage.encrypt(registration_data)
          registration_data['verification_url'] =
            "#{@config.APP_URL}/auth/signup/#{registration_token}"

          registration_data
        end
      end
    end
  end
end
