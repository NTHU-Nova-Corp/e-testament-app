# frozen_string_literal: true

module ETestament
  module Services
    # Account properties
    class Properties
      class UnauthorizedError < StandardError; end

      def initialize(config)
        @config = config
      end

      def all(current_account)
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/properties")
        response.parse['data'].map { |m| m['data']['attributes'] }
      end

      def create(current_account, name:, property_type_id:, description:)
        body = { name:, property_type_id:, description: }
        HTTP.auth("Bearer #{current_account.auth_token}")
            .post("#{@config.API_URL}/properties", json: body)
      end

      def update(current_account, id:, name:, property_type_id:, description:)
        body = { name:, property_type_id:, description: }
        HTTP.auth("Bearer #{current_account.auth_token}")
            .post("#{@config.API_URL}/properties/#{id}", json: body)
      end

      def delete(current_account, delete_property_id:)
        HTTP.auth("Bearer #{current_account.auth_token}")
            .post("#{@config.API_URL}/properties/#{delete_property_id}/delete")
      end

      def types
        response = HTTP.get("#{@config.API_URL}/property_types")
        response.parse['data'].map { |m| m['data']['attributes'] }
      end

      def documents(property_id)
        response = HTTP.get("#{@config.API_URL}/properties/#{property_id}/documents")
        JSON.parse(response).map { |m| m['data']['attributes'] }
      end

      def heirs(property_id)
        response = HTTP.get("#{@config.API_URL}/properties/#{property_id}/heirs")
        JSON.parse(response).map { |m| m['data']['attributes'] }
      end
    end
  end
end
