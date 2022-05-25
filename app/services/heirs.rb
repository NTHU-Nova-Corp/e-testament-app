# frozen_string_literal: true

module ETestament
  module Services
    # Heirs
    class Heirs
      class UnauthorizedError < StandardError; end
      class ApiServerError < StandardError; end

      def initialize(config)
        @config = config
        @api_path = "#{@config.API_URL}/heirs"
      end

      def all(current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get(@api_path)
        raise(ApiServerError) if response.code != 200

        response.parse['data'].map { |m| m['data']['attributes'] }
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def create(current_account, first_name:, last_name:, email:, relation_id:)
        body = { first_name:, last_name:, email:, relation_id: }
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/heirs", json: body)
        raise(ApiServerError) if response.code != 201

        response
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def relations
        response = HTTP.get("#{@config.API_URL}/relations")
        raise(ApiServerError) if response.code != 200

        response.parse['data'].map { |m| m['data']['attributes'] }
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end
    end
  end
end
