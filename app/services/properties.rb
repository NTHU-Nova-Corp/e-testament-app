# frozen_string_literal: true

module ETestament
  # Account properties
  class Properties
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def all
      response = HTTP.get("#{@config.API_URL}/properties")
      response.parse['data'].map { |m| m['data']['attributes'] }
    end

    def new(account_id:, name:, property_type_id:, description:)
      message = { name:, property_type_id:, description: }
      HTTP.headers(account_id:).post("#{@config.API_URL}/properties", json: message)
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
