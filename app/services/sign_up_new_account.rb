# frozen_string_literal: true

require 'http'

module ETestament
  # Returns an authenticated user, or nil
  class SignUpNewAccount
    # Error for accounts that cannot be created
    class InvalidAccount < StandardError
      def message = 'This account can no longer be created: please start again'
    end

    def initialize(config)
      @config = config
    end

    def call(username:, password:, first_name:, last_name:, email:)
      response = HTTP.post("#{@config.API_URL}/accounts",
                           json: { username:, password:, first_name:, last_name:, email: })

      raise InvalidAccount unless response.code == 201
    end
  end
end
