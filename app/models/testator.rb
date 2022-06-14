# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Testator
      attr_reader :id, :username, :first_name, :last_name, :email, :testament_status, :presentation_name

      def initialize(testator)
        @testator = testator
        return if testator.nil?

        @id = testator['attributes']['id']
        @username = testator['attributes']['username']
        @first_name = testator['attributes']['first_name']
        @last_name = testator['attributes']['last_name']
        @email = testator['attributes']['email']
        @testament_status = testator['attributes']['testament_status']
        @presentation_name = "#{@first_name} #{@last_name}"
      end

      def empty?
        @testator.nil?
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
