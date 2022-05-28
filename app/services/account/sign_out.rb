# frozen_string_literal: true

require 'http'

module ETestament
  module Services
    module Accounts
      # Sign out current session
      class SignOut
        def initialize(session)
          @session = session
        end

        def call
          Models::CurrentSession.new(@session).delete
        end
      end
    end
  end
end
