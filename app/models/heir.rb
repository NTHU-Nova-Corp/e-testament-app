# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Heir
      attr_reader :id, :first_name, :last_name, :email, :realation_id

      def initialize(property_info)
        @id = property_info['attributes']['id']
        @first_name = property_info['attributes']['first_name']
        @last_name = property_info['attributes']['last_name']
        @email = property_info['attributes']['email']
        @realation_id = property_info['attributes']['realation_id']
      end

      def to_json(options = {})
        JSON({
               id: @id,
               first_name: @first_name,
               last_name: @last_name,
               email: @email,
               realation_id: @realation_id
             }, options)
      end
    end
  end
end
