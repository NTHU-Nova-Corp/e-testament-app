# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class PropertiesDistribution
      attr_reader :all

      def initialize(properties)
        @all = properties.map do |property|
          Models::PropertyDistribution.new(property)
        end
      end
    end
  end
end
