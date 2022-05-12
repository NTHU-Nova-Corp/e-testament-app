# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    # rubocop:disable Metrics/BlockLength
    route('properties') do |routing|
      @properties_route = '/properties/[properties_id]'
      @documents_dir = 'properties'

      routing.on String do |property_id|
        @documents_route = "#{@properties_route}/#{property_id}/documents"
        routing.on 'documents' do
          routing.get do
            breadcrumb = "#{@documents_dir}/documents"
            update_breadcrumb_session(breadcrumb)
            view breadcrumb
          end
        end

        routing.on 'heirs' do
          routing.get do
            breadcrumb = "#{@documents_dir}/heirs"
            update_breadcrumb_session(breadcrumb)
            view breadcrumb
          end
        end

        routing.get do
          breadcrumb = "#{@documents_dir}/property"
          update_breadcrumb_session(breadcrumb)
          view breadcrumb
        end
      end

      # GET /properties
      routing.get do
        breadcrumb = 'properties'
        update_breadcrumb_session(breadcrumb)

        properties = Properties.new(App.config).all
        view "#{breadcrumb}/properties", locals: { properties: }
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
