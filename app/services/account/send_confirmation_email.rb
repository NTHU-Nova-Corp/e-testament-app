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
          regis_form = Services::Utils::GetRegistrationForm.new(@config).call(registration_data:)
          response = HTTP.post("#{@config.API_URL}/auth/register",
                               json: SignedMessage.sign(regis_form))

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
