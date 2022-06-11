# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class PropertyHeir
      attr_reader :id, :heir, :property, :percentage

      def initialize(property_heir)
        @id = property_heir['attributes']['id']
        @percentage = BigDecimal(property_heir['attributes']['percentage']).to_s('F').to_i
        @heir = Models::Heir.new(property_heir['relationships']['heir'])
        @property = Models::Property.new(property_heir['relationships']['property'])
      end

      def to_json(options = {})
        JSON({
               id: @id,
               percentage: @percentage,
               heir: @heir,
               property: @property
             }, options)
      end
    end
  end
end
