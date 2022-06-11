# frozen_string_literal: true

module ETestament
  # Models module
  module Models
    # Property model
    class Document
      attr_reader :id, :file_name, :type, :description, :content, :property_id

      def initialize(document)
        @id = document['attributes']['id']
        @file_name = document['attributes']['file_name']
        @type = document['attributes']['type']
        @description = document['attributes']['description']
        @content = document['attributes']['content']
        @property_id = document['attributes']['property_id']
      end

      def to_json(options = {})
        JSON({
               id: @id,
               file_name: @file_name,
               type: @type,
               description: @description,
               property_id: @property_id
             }, options)
      end
    end
  end
end
