# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Property
      attr_reader :id, :name, :description, :property_type_id

      def initialize(property_info)
        @id = property_info['attributes']['id']
        @name = property_info['attributes']['name']
        @description = property_info['attributes']['description']
        @property_type_id = property_info['attributes']['property_type_id']
      end

      def to_json(options = {})
        JSON({
               id: @id,
               name: @name,
               description: @description,
               property_type_id: @property_type_id
             }, options)
      end
    end
  end
end
