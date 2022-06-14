# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Executor
      ACTIVE_STATUS = 'Active'
      PENDING_REGISTRATION = 'Pending registration'
      PENDING_ACCEPTANCE = 'Pending acceptance'
      attr_reader :id, :username, :first_name, :last_name, :email, :presentation_name, :status

      def non_regis_executor(email)
        @email = email
        @status = PENDING_REGISTRATION
      end

      def regis_executor
        @id = @executor['id']
        @username = @executor['username']
        @first_name = @executor['first_name']
        @last_name = @executor['last_name']
        @email = @executor['email']
        @is_pending = @executor['is_pending']
        @presentation_name = "#{@first_name} #{@last_name}"
      end

      def initialize(executor = nil, status = nil)
        @executor = executor
        @status = status
        return if @executor.nil?

        if @executor['executor_email'].nil?
          regis_executor
        else
          non_regis_executor(@executor['executor_email'])
        end
      end

      def active
        ACTIVE_STATUS
      end

      def pending_acceptance
        PENDING_ACCEPTANCE
      end

      def pending_registration
        PENDING_REGISTRATION
      end

      def unassigned?
        @executor.nil?
      end

      def active?
        @status.eql?(active)
      end

      def pending_acceptance?
        @status.eql?(pending_acceptance)
      end

      def pending_registration?
        @status.eql?(PENDING_REGISTRATION)
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
