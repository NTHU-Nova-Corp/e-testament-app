# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda



    route('properties') do |routing|
      @properties_route = '/properties/[properties_id]'
      @documents_dir = 'properties'

      routing.on String do |property_id|
        @documents_route = "#{@properties_route}/#{property_id}/documents"
        routing.on 'documents' do
          routing.get do
            breadcrumb = "#{@documents_dir}/documents"
            self.update_breadcrumb_session(breadcrumb)
            view breadcrumb
          end
        end

        routing.on 'heirs' do
          routing.get do
            breadcrumb = "#{@documents_dir}/heirs"
            self.update_breadcrumb_session(breadcrumb)
            view breadcrumb
          end
        end

        routing.get do
          breadcrumb = "#{@documents_dir}/property"
          self.update_breadcrumb_session(breadcrumb)
          view breadcrumb
        end
      end

      # GET /properties
      routing.get do
        breadcrumb = 'properties'
        self.update_breadcrumb_session(breadcrumb)

        properties = Properties.new(App.config).all
        view "#{breadcrumb}/properties", locals: { properties: }
      end
    end

  end
end

