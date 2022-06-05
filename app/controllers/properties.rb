# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    # rubocop:disable Metrics/BlockLength
    route('properties') do |routing|
      @properties_route = '/properties'
      @properties_dir = 'properties'

      if @current_account.logged_in?
        routing.post 'update' do
          Services::Properties::Update.new(App.config).call(current_account: @current_account,
                                                            id: routing.params['update_property_id'],
                                                            name: routing.params['update_name'],
                                                            property_type_id: routing.params['update_property_type_id'],
                                                            description: routing.params['update_description'])

          flash[:notice] = 'Property has been updated!'
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
        ensure
          routing.redirect @properties_route
        end

        routing.post 'delete' do
          delete_property_id = routing.params['delete_property_id']
          Services::Properties::Delete.new(App.config).call(current_account: @current_account, delete_property_id:)

          flash[:notice] = 'Property has been deleted!'
          routing.redirect '/properties'
        end

        routing.on String do |property_id|
          @documents_route = "#{@properties_route}/#{property_id}/documents"
          routing.on 'documents' do
            routing.get do
              dir_path = get_view_path("#{@properties_dir}/documents")
              documents = Services::Properties::Documents::GetAll.new(App.config)
                                                                 .call(current_account: @current_account,
                                                                       property_id:)

              view dir_path, locals: { current_account: @current_account, documents: }
            end
          end

          routing.on 'heirs' do
            routing.get do
              dir_path = get_view_path("#{@properties_dir}/heirs")
              property_heirs = Services::PropertyHeirs::GetHeirsRelatedWithProperty
                               .new(App.config)
                               .call(current_account: @current_account, property_id:)
              relations = Services::Heirs::GetRelations.new(App.config).call(current_account: @current_account)

              view dir_path, locals: { current_account: @current_account, property_heirs:, relations: }
            end
          end

          routing.get do
            dir_path = get_view_path("#{@properties_dir}/property")

            view dir_path
          end
        end

        # GET /properties
        routing.get do
          dir_path = get_view_path('properties', 'properties')

          properties = Services::Properties::GetAll.new(App.config).call(current_account: @current_account)
          types = Services::Properties::GetTypes.new(App.config).call(current_account: @current_account)
          view dir_path, locals: { current_account: @current_account, properties:, types: }
        end

        # POST /properties
        routing.post do
          new_property = JsonRequestBody.symbolize(routing.params)
          # account_id:, name:, property_type_id:, description:
          Services::Properties::Create.new(App.config).call(current_account: @current_account, **new_property)
          flash[:notice] = 'Add documents and heirs to your new property'
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
        ensure
          routing.redirect @properties_route
        end
      else
        routing.redirect '/auth/signin'
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
