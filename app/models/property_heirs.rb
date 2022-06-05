# frozen_string_literal: true

require_relative 'heir'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class PropertyHeirs
      attr_reader :all

      def initialize(property_heirs_list)
        @all = property_heirs_list.map do |heir|
          Models::Property_Heir.new(heir)
        end
      end
    end
  end
end
