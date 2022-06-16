# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Testament
      # Get all testators related with an account
      class MarkAsComplete
        def initialize(config, session)
          @config = config
          @session = session
        end

        def call(current_account:, min_amount_heirs:)
          response = HTTP.auth("Bearer #{current_account.auth_token}")
                         .post("#{@config.API_URL}/testaments/complete", json: { min_amount_heirs: })

          response_data = JSON.parse(response.to_s)
          raise Exceptions::BadRequestError, response_data['message'] if response.code == 400
          raise Exceptions::ApiServerError if response.code != 200

          current_account.set_testament_status(testament_status: 'Completed')
          Models::CurrentSession.new(@session).current_account = current_account
        rescue HTTP::ConnectionError
          raise Exceptions::ApiServerError
        end
      end
    end
  end
end
