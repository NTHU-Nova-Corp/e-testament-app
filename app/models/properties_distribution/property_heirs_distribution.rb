# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class PropertyHeirsDistribution
      attr_reader :all

      def initialize(property_heirs_distribution)
        @all = property_heirs_distribution.map do |property_heir|
          Models::PropertyHeirDistribution.new(property_heir)
        end
      end
    end
  end
end
