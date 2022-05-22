# frozen_string_literal: true

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Project
      attr_reader :id, :name, :repo_url

      def initialize(proj_info)
        @id = proj_info['attributes']['id']
        @name = proj_info['attributes']['name']
        @repo_url = proj_info['attributes']['repo_url']
      end
    end
  end
end
