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

      if @current_account.logged_in?
        routing.post 'update' do
          id = routing.params['update_property_id']
          name = routing.params['update_name']
          property_type_id = routing.params['update_property_type_id']
          description = routing.params['update_description']

          Services::Properties.new(App.config).update(@current_account,
                                                      id:,
                                                      name:,
                                                      property_type_id:,
                                                      description:)

          flash[:notice] = 'Property has been updated!'
          routing.redirect '/properties'
        end

        routing.post 'delete' do
          delete_property_id = routing.params['delete_property_id']
          Services::Properties.new(App.config).delete(@current_account, delete_property_id:)

          flash[:notice] = 'Property has been deleted!'
          routing.redirect '/properties'
        end

        routing.on String do |property_id|
          @documents_route = "#{@properties_route}/#{property_id}/documents"
          routing.on 'documents' do
            routing.get do
              dir_path = get_view_path("#{@documents_dir}/documents")
              documents = Services::Properties.new(App.config).documents(property_id)

              view dir_path, locals: { current_user: @current_account, documents: }
            end
          end

          routing.on 'heirs' do
            routing.get do
              dir_path = get_view_path("#{@documents_dir}/heirs")
              heirs = Services::Properties.new(App.config).heirs(property_id)
              relations = Services::Heirs.new(App.config).relations

              view dir_path, locals: { current_user: @current_account, heirs:, relations: }
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

          properties = Services::Properties.new(App.config).all(@current_account)
          types = Services::Properties.new(App.config).types
          view dir_path, locals: { current_user: @current_account, properties:, types: }
        end

        # POST /properties
        routing.post do
          new_property = JsonRequestBody.symbolize(routing.params)
          # account_id:, name:, property_type_id:, description:
          Services::Properties.new(App.config).create(@current_account, **new_property)

          flash[:notice] = 'Property has been created!'
          routing.redirect '/properties'
        end
      else
        routing.redirect '/auth/signin'
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
