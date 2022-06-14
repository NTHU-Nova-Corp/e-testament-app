# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class PropertyDistribution
      attr_reader :id, :name, :description, :heirs

      def initialize(property_info)
        @id = property_info['attributes']['id']
        @name = property_info['attributes']['name']
        @description = property_info['attributes']['description']
        @heirs = Models::PropertyHeirsDistribution.new(property_info['attributes']['heirs'])
      end

      def to_json(options = {})
        JSON({
               id: @id,
               first_name: @first_name,
               last_name: @last_name,
               email: @email,
               testament_status: @testament_status,
               presentation_name: @presentation_name
             }, options)
      end
    end
  end
end
