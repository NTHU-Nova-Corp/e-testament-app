# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class PropertyHeirDistribution
      attr_reader :id, :first_name, :last_name, :email, :percentage

      def initialize(property_heir_distribution_info)
        @id = property_heir_distribution_info['attributes']['id']
        @first_name = property_heir_distribution_info['attributes']['first_name']
        @last_name = property_heir_distribution_info['attributes']['last_name']
        @email = property_heir_distribution_info['attributes']['email']
        @percentage = BigDecimal(property_heir_distribution_info['attributes']['percentage']).to_s('F').to_i
      end
    end
  end
end
