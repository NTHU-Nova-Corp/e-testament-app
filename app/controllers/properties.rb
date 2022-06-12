# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  # rubocop:disable Metrics/ClassLength
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

          flash[:notice] = 'Property updated!'
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
        ensure
          routing.redirect @properties_route
        end

        routing.post 'delete' do
          delete_property_id = routing.params['delete_property_id']
          Services::Properties::Delete.new(App.config).call(current_account: @current_account, delete_property_id:)

          flash[:notice] = 'Property deleted!'
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
        ensure
          routing.redirect @properties_route
        end

        routing.on String do |property_id|
          routing.on 'documents' do
            @documents_route = "#{@properties_route}/#{property_id}/documents"

            routing.on String do |document_id|
              routing.post 'delete' do
                Services::Properties::Documents::Delete.new(App.config)
                                                       .call(current_account: @current_account,
                                                             property_id:,
                                                             document_id:)

                flash[:notice] = 'Document deleted!'
              rescue Exceptions::BadRequestError => e
                flash[:error] = "Error: #{e.message}"
              ensure
                routing.redirect @documents_route
              end

              routing.get do
                dir_path = get_view_path("#{@properties_dir}/documents")
                documents = Services::Properties::Documents::GetAll.new(App.config)
                                                                   .call(current_account: @current_account,
                                                                         property_id:)
                document_to_download = Services::Properties::Documents::Get.new(App.config)
                                                                           .call(current_account: @current_account,
                                                                                 property_id:,
                                                                                 document_id:)

                view dir_path,
                     locals: { current_account: @current_account, property_id:, documents:, document_to_download: }
              rescue Exceptions::BadRequestError => e
                flash[:error] = "Error: #{e.message}"
                routing.redirect @documents_route
              end
            end

            routing.get do
              dir_path = get_view_path("#{@properties_dir}/documents")
              documents = Services::Properties::Documents::GetAll.new(App.config)
                                                                 .call(current_account: @current_account,
                                                                       property_id:)

              view dir_path,
                   locals: { current_account: @current_account, property_id:, documents:, document_to_download: nil }
            end

            routing.post do
              file = routing.params['formFile']
              Services::Properties::Documents::Create.new(App.config)
                                                     .call(current_account: @current_account,
                                                           property_id:,
                                                           file_name: file[:filename],
                                                           type: file[:type],
                                                           description: routing.params['description'],
                                                           content: Base64.strict_encode64(file[:tempfile].read))

              flash[:notice] = 'Document created!'
            rescue Exceptions::BadRequestError => e
              flash[:error] = "Error: #{e.message}"
            ensure
              routing.redirect @documents_route
            end
          end

          routing.on 'heirs' do
            @heirs_route = "#{@properties_route}/#{property_id}/heirs"

            routing.on String do |heir_id|
              routing.post 'delete' do
                Services::PropertyHeirs::DeleteAssociationBetweenPropertyAndHeir.new(App.config)
                                                                                .call(current_account: @current_account,
                                                                                      heir_id:,
                                                                                      property_id:)

                flash[:notice] = 'Heir association deleted to property!'
              rescue Exceptions::BadRequestError => e
                flash[:error] = "Error: #{e.message}"
              ensure
                routing.redirect @heirs_route
              end

              routing.post 'update' do
                Services::PropertyHeirs::UpdatePropertyHeir.new(App.config)
                                                           .call(current_account: @current_account,
                                                                 heir_id:,
                                                                 property_id:,
                                                                 percentage: routing.params['update_percentage'])

                flash[:notice] = 'Heir association updated!'
              rescue Exceptions::BadRequestError => e
                flash[:error] = "Error: #{e.message}"
              ensure
                routing.redirect @heirs_route
              end
            end

            routing.get do
              dir_path = get_view_path("#{@properties_dir}/heirs")
              property_heirs = Services::PropertyHeirs::GetHeirsRelatedWithProperty
                               .new(App.config)
                               .call(current_account: @current_account, property_id:)
              heirs = Services::Heirs::GetAll.new(App.config).call(current_account: @current_account)

              view dir_path,
                   locals: { current_account: @current_account, property_id:, property_heirs:, heirs: }
            end

            routing.post do
              Services::PropertyHeirs::AssociatePropertyHeir.new(App.config)
                                                            .call(current_account: @current_account,
                                                                  heir_id: routing.params['add_heir_id'],
                                                                  property_id:,
                                                                  percentage: routing.params['percentage'])

              flash[:notice] = 'Heir associated to property!'
            rescue Exceptions::BadRequestError => e
              flash[:error] = "Error: #{e.message}"
            ensure
              routing.redirect @heirs_route
            end
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
  # rubocop:enable Metrics/ClassLength
end
