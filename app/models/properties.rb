# frozen_string_literal: true

require_relative 'property'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Projects
      attr_reader :all

      def initialize(projects_list)
        @all = projects_list.map do |proj|
          Models::Property.new(proj)
        end
      end
    end
  end
end
