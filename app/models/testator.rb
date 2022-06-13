# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Testator
      attr_reader :id, :username, :first_name, :last_name, :email, :presentation_name

      def initialize(heir_info)
        @id = heir_info['attributes']['id']
        @username = heir_info['attributes']['username']
        @first_name = heir_info['attributes']['first_name']
        @last_name = heir_info['attributes']['last_name']
        @email = heir_info['attributes']['email']
        @presentation_name = "#{@first_name} #{@last_name}"
      end

      def to_json(options = {})
        JSON({
               id: @id,
               first_name: @first_name,
               last_name: @last_name,
               email: @email,
               presentation_name: @presentation_name
             }, options)
      end
    end
  end
end
