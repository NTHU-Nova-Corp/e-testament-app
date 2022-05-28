# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Accounts
      # Sends confirmation email for new sign up
      class SendConfirmationEmail
        def initialize(config)
          @config = config
        end

        def call(registration_data:)
          registration_token = SecureMessage.encrypt(registration_data)
          registration_data['verification_url'] =
            "#{@config.APP_URL}/auth/signup/#{registration_token}"

          response = HTTP.post("#{@config.API_URL}/auth/register",
                               json: registration_data)

          response_data = JSON.parse(response.to_s)
          raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
          raise Exceptions::BadRequestError if response.code != 202
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
        # rubocop:enabe Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
