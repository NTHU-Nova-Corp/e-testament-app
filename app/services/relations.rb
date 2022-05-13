# frozen_string_literal: true

module ETestament
  # Relations
  class Relations
    def initialize(config)
      @config = config
      @api_path = "#{@config.API_URL}/relations"
    end

    def all(account_id)
      response = HTTP.headers(account_id:).get(@api_path)
      response.parse['data'].map { |m| m['data']['attributes'] }
    end
  end
end
