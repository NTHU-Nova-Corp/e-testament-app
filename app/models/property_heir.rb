# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class PropertyHeir
      attr_reader :id, :heir, :property

      def initialize(property_info)
        @id = property_info['attributes']['id']
        @heir = Models::Heir.new(property_info['attributes']['heir'])
        @property = Models::Property.new(property_info['attributes']['property'])
      end
    end

    def to_json(options = {})
      JSON({
             id: @id,
             heir: @heir.to_json,
             property: @property.to_json
           }, options)
    end
  end
end
