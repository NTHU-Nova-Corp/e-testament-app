# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Executor
      attr_reader :id, :username, :first_name, :last_name, :email, :presentation_name

      def initialize(executor)
        @executor = executor
        return if @executor.nil?

        @id = @executor['id']
        @username = @executor['username']
        @first_name = @executor['first_name']
        @last_name = @executor['last_name']
        @email = @executor['email']
        @is_pending = @executor['is_pending']
        @presentation_name = "#{@first_name} #{@last_name}"
      end

      def unassigned?
        @executor.nil?
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
