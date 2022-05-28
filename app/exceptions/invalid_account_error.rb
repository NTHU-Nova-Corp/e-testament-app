# frozen_string_literal: true

module ETestament
  module Exceptions
    # Invalid Account Error
    class InvalidAccountError < StandardError
      def message = 'This account can no longer be created: please start again'
    end
  end
end
