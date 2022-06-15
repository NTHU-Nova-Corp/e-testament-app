# frozen_string_literal: true

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Account
      def initialize(account_info, auth_token)
        @account_info = account_info
        @auth_token = auth_token
      end

      attr_reader :account_info, :auth_token

      def username
        @account_info ? @account_info['username'] : nil
      end

      def email
        @account_info ? @account_info['email'] : nil
      end

      def testament_status
        @account_info ? @account_info['testament_status'] : nil
      end

      def set_testament_status(testament_status:)
        @account_info['testament_status'] = testament_status
      end

      def logged_out?
        @account_info.nil?
      end

      def logged_in?
        !logged_out?
      end
    end
  end
end
