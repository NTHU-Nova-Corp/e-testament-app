# frozen_string_literal: true

require_relative 'document'

module ETestament
  module Models
    # Behaviors of the currently logged in account
    class Documents
      attr_reader :all

      def initialize(documents_list)
        @all = documents_list.map do |document|
          Models::Document.new(document)
        end
      end
    end
  end
end
