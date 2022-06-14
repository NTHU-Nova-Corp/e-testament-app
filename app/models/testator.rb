# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Testator
      attr_reader :id, :username, :first_name, :last_name, :email, :testament_status, :presentation_name

      def initialize(testator_info)
        puts testator_info
        @id = testator_info['attributes']['id']
        @username = testator_info['attributes']['username']
        @first_name = testator_info['attributes']['first_name']
        @last_name = testator_info['attributes']['last_name']
        @email = testator_info['attributes']['email']
        @testament_status = testator_info['attributes']['testament_status']
        @presentation_name = "#{@first_name} #{@last_name}"
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
