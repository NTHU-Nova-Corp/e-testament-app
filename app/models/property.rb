# frozen_string_literal: true

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Project
      attr_reader :id, :name

      def initialize(proj_info)
        @id = proj_info['attributes']['id']
        @name = proj_info['attributes']['name']
        @type = proj_info['attributes']['name']
      end
    end
  end
end
