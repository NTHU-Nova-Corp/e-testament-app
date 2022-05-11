# frozen_string_literal: true

require 'http'

module ETestament
  # Returns an authenticated user, or nil
  class SignUpNewAccount

    def initialize(config)
      @config = config
    end

    def call(username:, password:, first_name:, last_name:, email:)
      response = HTTP.post("#{@config.API_URL}/accounts",
                           json: { username:, password:, first_name:, last_name:, email: })

      raise(StandardError) unless response.code == 201

      response.parse['data']['data']['attributes']
    end
  end
end
