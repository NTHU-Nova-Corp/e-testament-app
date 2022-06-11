# frozen_string_literal: true

require_relative 'heir'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class PropertyHeirs
      attr_reader :all

      def initialize(property_heirs_list)
        @all = property_heirs_list.map do |property_heir|
          Models::PropertyHeir.new(property_heir)
        end
      end
    end
  end
end
