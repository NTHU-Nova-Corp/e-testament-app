# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    # rubocop:disable Metrics/BlockLength
    route('heirs') do |routing|
      @heirs_route = '/heirs'
      @heirs_dir = 'heirs'

      routing.redirect '/auth/signin' unless @current_account.logged_in?

      routing.post 'update' do
        Services::Heirs::Update.new(App.config).call(current_account: @current_account,
                                                     id: routing.params['update_heir_id'],
                                                     first_name: routing.params['update_first_name'],
                                                     last_name: routing.params['update_last_name'],
                                                     email: routing.params['update_email'],
                                                     relation_id: routing.params['update_relation_id'])
        flash[:notice] = 'Heir updated!'
        routing.redirect @heirs_route
      rescue Exceptions::BadRequestError => e
        flash[:error] = "Error: #{e.message}"
        routing.redirect @heirs_route
      end

      routing.post 'delete' do
        delete_heir_id = routing.params['delete_heir_id']
        Services::Heirs::Delete.new(App.config).call(current_account: @current_account, delete_heir_id:)

        flash[:notice] = 'Heir deleted!'
        routing.redirect @heirs_route
      rescue Exceptions::BadRequestError => e
        flash[:error] = "Error: #{e.message}"
        routing.redirect @heirs_route
      end

      routing.on String do |heir_id|
        routing.on 'properties' do
          @properties_route = "#{@heirs_route}/#{heir_id}/properties"

          routing.on String do |property_id|
            routing.post 'delete' do
              Services::PropertyHeirs::DeleteAssociationBetweenPropertyAndHeir.new(App.config)
                                                                              .call(current_account: @current_account,
                                                                                    heir_id:,
                                                                                    property_id:)

              flash[:notice] = 'Property associated deleted from heir!'
              routing.redirect @properties_route
            rescue Exceptions::BadRequestError => e
              flash[:error] = "Error: #{e.message}"
              routing.redirect @properties_route
            end

            routing.post 'update' do
              Services::PropertyHeirs::UpdatePropertyHeir.new(App.config)
                                                         .call(current_account: @current_account,
                                                               heir_id:,
                                                               property_id:,
                                                               percentage: routing.params['update_percentage'])

              flash[:notice] = 'Property association updated!'
              routing.redirect @properties_route
            rescue Exceptions::BadRequestError => e
              flash[:error] = "Error: #{e.message}"
              routing.redirect @properties_route
            end
          end

          routing.get do
            property_heirs = Services::PropertyHeirs::GetPropertiesRelatedWitHeir
                             .new(App.config)
                             .call(current_account: @current_account, heir_id:)
            properties = Services::Properties::GetAll.new(App.config).call(current_account: @current_account)
            heir = Services::Heirs::GetInfo.new(App.config).call(current_account: @current_account, heir_id:)

            dir_path = get_view_path(breadcrumb: "#{@heirs_dir}/properties", display: heir.presentation_name)
            view dir_path,
                 locals: { heir_id:, property_heirs:, properties:, testament_status: @current_account.testament_status }
          end

          routing.post do
            Services::PropertyHeirs::AssociatePropertyHeir.new(App.config)
                                                          .call(current_account: @current_account,
                                                                heir_id:,
                                                                property_id: routing.params['add_property_id'],
                                                                percentage: routing.params['percentage'])

            flash[:notice] = 'Property associated to heir!'
            routing.redirect @properties_route
          rescue Exceptions::BadRequestError => e
            flash[:error] = "Error: #{e.message}"
            routing.redirect @properties_route
          end
        end
      end

      # GET /heirs
      routing.get do
        dir_path = get_view_path(breadcrumb: 'heirs', in_page: 'heirs')
        relations = Services::Heirs::GetRelations.new(App.config).call(current_account: @current_account)
        heirs = Services::Heirs::GetAll.new(App.config).call(current_account: @current_account)
        view dir_path, locals: { heirs:, relations:, testament_status: @current_account.testament_status }
      end

      # POST /heirs
      routing.post do
        new_heir = JsonRequestBody.symbolize(routing.params)
        # first_name:, last_name:, email:, relation_id
        Services::Heirs::Create.new(App.config).call(current_account: @current_account, **new_heir)

        flash[:notice] = 'Heir created!'
        routing.redirect @heirs_route
      rescue Exceptions::BadRequestError => e
        flash[:error] = "Error: #{e.message}"
        routing.redirect @heirs_route
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
