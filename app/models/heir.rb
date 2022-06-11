# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Heir
      attr_reader :id, :first_name, :last_name, :email, :relation_id, :relation, :presentation_name

      # rubocop:disable Metrics/AbcSize
      def initialize(property_info)
        @id = property_info['attributes']['id']
        @first_name = property_info['attributes']['first_name']
        @last_name = property_info['attributes']['last_name']
        @email = property_info['attributes']['email']
        @relation_id = property_info['attributes']['relation_id']
        @relation = property_info['attributes']['relation']
        @presentation_name = "
          #{property_info['attributes']['first_name']}
          #{property_info['attributes']['last_name']} (#{property_info['attributes']['relation']})"
      end
      # rubocop:enable Metrics/AbcSize

      def to_json(options = {})
        JSON({
               id: @id,
               first_name: @first_name,
               last_name: @last_name,
               email: @email,
               relation_id: @relation_id,
               relation: @relation
             }, options)
      end
    end
  end
end
