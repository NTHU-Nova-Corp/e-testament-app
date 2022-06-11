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

      def pending_to_assign(property_heirs:)
        properties_associated = property_heirs.map { |property_heir| property_heir.property.id }
        @all.reject { |property| properties_associated.include? property.id }
      end
    end
  end
end
