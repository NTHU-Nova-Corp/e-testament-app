# frozen_string_literal: true

require_relative 'heir'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Testators
      attr_reader :all

      def initialize(testators)
        @all = testators.map do |testator|
          Models::Testator.new(testator)
        end
      end
    end
  end
end
