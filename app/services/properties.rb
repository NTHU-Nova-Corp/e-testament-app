# frozen_string_literal: true

module ETestament
  module Services
    # Account properties
    class Properties
      class UnauthorizedError < StandardError; end
      class ApiServerError < StandardError; end

      def initialize(config)
        @config = config
      end

      def all(current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/properties")
        raise(ApiServerError) if response.code != 200

        response.parse['data'].map { |m| m['data']['attributes'] }
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def create(current_account, name:, property_type_id:, description:)
        body = { name:, property_type_id:, description: }
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/properties", json: body)
        raise(ApiServerError) if response.code != 201

        response
      rescue HTTP::ConnectionError
        raise ApiServerError
      end

      def update(current_account, id:, name:, property_type_id:, description:)
        body = { name:, property_type_id:, description: }
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/properties/#{id}", json: body)
        raise(ApiServerError) if response.code != 200

        response
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def delete(current_account, delete_property_id:)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post("#{@config.API_URL}/properties/#{delete_property_id}/delete")
        raise(ApiServerError) if response.code != 200

        response
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def types
        response = HTTP.get("#{@config.API_URL}/property_types")
        raise(ApiServerError) if response.code != 200

        response.parse['data'].map { |m| m['data']['attributes'] }
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def documents(property_id)
        response = HTTP.get("#{@config.API_URL}/properties/#{property_id}/documents")
        raise(ApiServerError) if response.code != 200

        JSON.parse(response).map { |m| m['data']['attributes'] }
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end

      def heirs(property_id)
        response = HTTP.get("#{@config.API_URL}/properties/#{property_id}/heirs")
        raise(ApiServerError) if response.code != 200

        JSON.parse(response).map { |m| m['data']['attributes'] }
      rescue HTTP::ConnectionError
        raise(ApiServerError)
      end
    end
  end
end
