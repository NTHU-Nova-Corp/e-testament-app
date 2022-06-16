# frozen_string_literal: true

require_relative 'heir'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Heirs
      attr_reader :all

      def initialize(heirs_list)
        @all = heirs_list.map do |heir|
          Models::Heir.new(heir)
        end
      end

      def pending_to_assign(property_heirs:)
        heirs_associated = property_heirs.map { |property_heir| property_heir.heir.id }
        @all.reject { |heir| heirs_associated.include? heir.id }
      end

      def amount_signed?
        @all.count(&:key_submitted)
      end
    end
  end
end
