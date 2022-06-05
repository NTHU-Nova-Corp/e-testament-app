# frozen_string_literal: true

require_relative 'property'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Properties
      attr_reader :all

      def initialize(properties_list)
        @all = properties_list.map do |property|
          Models::Property.new(property)
        end
      end
    end
  end
end
