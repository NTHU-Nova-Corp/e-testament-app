# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  # rubocop:disable Metrics/ClassLength
  class App < Roda
    # rubocop:disable Metrics/BlockLength
    route('testators') do |routing|
      @testators_route = '/testators'
      @testators_dir = 'testators'

      routing.on 'submit-key' do
        routing.on String do |token|
          @submit_key_route = "/testators/submit-key/#{token}"
          routing.get do
            heir_data = SecureMessage.decrypt(token)
            view 'testators/submit_key',
                 locals: { token:, heir_presentation_name: heir_data['heir_presentation_name'],
                           heir_id: heir_data['heir_id'] }

            # view 'testators/submit_key', locals: { token:, heir_presentation_name: 'Cesar', heir_id: 'test' }
          end

          routing.post do
            heir_data = SecureMessage.decrypt(token)

            Services::Testators::Heirs::SubmitKey.new(App.config)
                                                 .call(heir_id: heir_data['heir_id'],
                                                       heir_key: routing.params['percentage'])

            flash[:notice] = 'Key submitted!'
            routing.redirect @submit_key_route
          rescue Exceptions::BadRequestError => e
            flash[:error] = "Error: #{e.message}"
            routing.redirect @submit_key_route
          end
        end
      end

      routing.redirect '/auth/signin' unless @current_account.logged_in?

      review_dir_path = get_view_path(breadcrumb: 'review', in_page: 'review')

      routing.get 'review' do
        view review_dir_path, locals: { testator: @request_testator, status: 'review' }
      end

      routing.on String do |testator_id|
        # POST /testators/:testator_id/reject
        routing.post 'reject' do
          Services::Testators::RejectRequest.new(App.config).call(current_account: @current_account,
                                                                  testator_id:)
          flash[:notice] = 'The invitation has been rejected!'
          routing.redirect '/'
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
          routing.redirect '/'
        end

        # POST /testators/:testator_id/accept
        routing.post 'accept' do
          Services::Testators::AcceptRequest.new(App.config).call(current_account: @current_account,
                                                                  testator_id:)
          flash[:notice] = 'The invitation has been accepted!'
          routing.redirect @testators_route
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
          routing.redirect @testators_route
        end

        # POST /testators/:testator_id/release
        routing.post 'release' do
          Services::Testators::ReleaseTestament.new(App.config).call(current_account: @current_account,
                                                                     testator_id:)
          flash[:notice] = 'The testament has been released!'
          routing.redirect @testators_route
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
          routing.redirect @testators_route
        end

        routing.get 'validate-keys' do
          testator = Services::Testators::GetInfo.new(App.config).call(current_account: @current_account, testator_id:)
          heirs = Services::Testators::Heirs::GetAll.new(App.config).call(current_account: @current_account,
                                                                          testator_id:)
          dir_path = get_view_path(breadcrumb: "#{@testators_dir}/testament_key_validator",
                                   display: testator.presentation_name)
          view dir_path, locals: { testator:, heirs: }
        end

        routing.on 'read' do
          routing.on 'properties' do
            routing.on String do |property_id|
              routing.on 'documents' do
                routing.on String do |document_id|
                  routing.get do
                    testator = Services::Testators::GetInfo.new(App.config)
                                                           .call(current_account: @current_account, testator_id:)

                    documents = Services::Testators::Documents::GetAll.new(App.config)
                                                                      .call(current_account: @current_account,
                                                                            testator_id:,
                                                                            property_id:)

                    document_to_download = Services::Testators::Documents::Get.new(App.config)
                                                                              .call(current_account: @current_account,
                                                                                    testator_id:,
                                                                                    property_id:,
                                                                                    document_id:)

                    dir_path = get_view_path(breadcrumb: "#{@testators_dir}/documents",
                                             display: testator.presentation_name)

                    view dir_path,
                         locals: { property_id:, testator:, documents:, document_to_download: }
                  rescue Exceptions::BadRequestError => e
                    flash[:error] = "Error: #{e.message}"
                    routing.redirect @documents_route
                  end
                end

                routing.get do
                  testator = Services::Testators::GetInfo.new(App.config)
                                                         .call(current_account: @current_account, testator_id:)

                  documents = Services::Testators::Documents::GetAll.new(App.config)
                                                                    .call(current_account: @current_account,
                                                                          testator_id:,
                                                                          property_id:)

                  dir_path = get_view_path(breadcrumb: "#{@testators_dir}/documents",
                                           display: testator.presentation_name)

                  view dir_path,
                       locals: { property_id:, testator:, documents:, document_to_download: nil }
                end
              end
            end
          end

          routing.post do
            testator = Services::Testators::GetInfo.new(App.config)
                                                   .call(current_account: @current_account, testator_id:)

            Services::Testators::ReadTestament.new(App.config).call(current_account: @current_account, testator_id:)
            properties = Services::Testators::GetTestament.new(App.config).call(current_account: @current_account,
                                                                                testator_id:)

            dir_path = get_view_path(breadcrumb: "#{@testators_dir}/testament_read",
                                     display: testator.presentation_name)
            view dir_path, locals: { testator:, properties: }
          end

          routing.get do
            testator = Services::Testators::GetInfo.new(App.config).call(current_account: @current_account,
                                                                         testator_id:)
            properties = Services::Testators::GetTestament.new(App.config).call(current_account: @current_account,
                                                                                testator_id:)

            dir_path = get_view_path(breadcrumb: "#{@testators_dir}/testament_read",
                                     display: testator.presentation_name)
            view dir_path, locals: { testator:, properties: }
          end
        end

        # GET /testators/:testator_id
        routing.get 'heirs' do
          heirs = Services::Testators::Heirs::GetAll.new(App.config).call(current_account: @current_account,
                                                                          testator_id:)
          testator = Services::Testators::GetInfo.new(App.config).call(current_account: @current_account, testator_id:)
          dir_path = get_view_path(breadcrumb: "#{@testators_dir}/heirs", display: testator.presentation_name)
          view dir_path, locals: { heirs: }
        end
      end

      # GET /testators
      routing.get do
        dir_path = get_view_path(breadcrumb: 'testators', in_page: 'testators')

        testators = Services::Testators::GetAll.new(App.config).call(current_account: @current_account)

        view dir_path, locals: { testators: }
      end
    end
    # rubocop:enable Metrics/BlockLength
  end

  # rubocop:enable Metrics/ClassLength
end
