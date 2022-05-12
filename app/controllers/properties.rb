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
            dir_path = get_view_path("#{@documents_dir}/documents")
            documents = Properties.new(App.config).documents(property_id)

            view dir_path, locals: { documents: }
          end
        end

        routing.on 'heirs' do
          routing.get do
            dir_path = get_view_path("#{@documents_dir}/heirs")
            heirs = Properties.new(App.config).heirs(property_id)

            view dir_path, locals: { heirs: }
          end
        end

        routing.get do
          dir_path = get_view_path("#{@documents_dir}/property")

          view dir_path
        end
      end

      # GET /properties
      routing.get do
        dir_path = get_view_path('properties', 'properties')

        properties = Properties.new(App.config).all
        types = Properties.new(App.config).types
        view dir_path, locals: { properties:, types: }
      end

      # POST /properties
      routing.post do
        new_property = JsonRequestBody.symbolize(routing.params)
        # account_id:, name:, property_type_id:, description:
        Properties.new(App.config).new(account_id: @current_account['id'], **new_property)

        flash[:notice] = 'Property has been created!'
        routing.redirect '/properties'
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
