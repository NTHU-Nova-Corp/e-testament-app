# Returns an authenticated user, or nil

module ETestament
  class Properties
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
      @api_path = "#{@config.API_URL}/properties"
    end

    def all
      response = HTTP.get(@api_path)
      response.parse['data'].map { |m| m['data']['attributes'] }
    end
  end
end
