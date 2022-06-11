# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Heir
      attr_reader :id, :first_name, :last_name, :email, :relation_id, :relation, :presentation_name

      # rubocop:disable Metrics/AbcSize
      def initialize(heir_info)
        @id = heir_info['attributes']['id']
        @first_name = heir_info['attributes']['first_name']
        @last_name = heir_info['attributes']['last_name']
        @email = heir_info['attributes']['email']
        @relation_id = heir_info['attributes']['relation_id']
        @relation = heir_info['attributes']['relation']
        @presentation_name = "
          #{heir_info['attributes']['first_name']}
          #{heir_info['attributes']['last_name']} (#{heir_info['attributes']['relation']})"
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
