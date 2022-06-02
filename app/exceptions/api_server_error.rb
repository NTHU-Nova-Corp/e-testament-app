# frozen_string_literal: true

module ETestament
  module Exceptions
    # Bad request exception
    class ApiServerError < StandardError
      def initialize(msg = 'Error: Our servers are not responding. Please try later',
                     exception_type = 'custom', _redirect_route = '/')
        @exception_type = exception_type
        @status_code = 500
        super(msg)
      end
    end
  end
end
