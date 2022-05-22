# frozen_string_literal: true

module ETestament
  module Services
    # Heirs
    class Heirs
      class UnauthorizedError < StandardError; end

      def initialize(config)
        @config = config
        @api_path = "#{@config.API_URL}/heirs"
      end

      def all(current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get(@api_path)
        response.parse['data'].map { |m| m['data']['attributes'] }
      end

      def relations
        response = HTTP.get("#{@config.API_URL}/relations")
        response.parse['data'].map { |m| m['data']['attributes'] }
      end
    end
  end
end
