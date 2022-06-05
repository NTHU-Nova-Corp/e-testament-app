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
    end
  end
end
