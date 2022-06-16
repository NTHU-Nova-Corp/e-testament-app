# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    # rubocop:disable Metrics/BlockLength
    route('testators') do |routing|
      @testators_route = '/testators'
      @testators_dir = 'testators'

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
          flash[:notice] = 'The invitation has been rejected!'
          routing.redirect @testators_route
        rescue Exceptions::BadRequestError => e
          flash[:error] = "Error: #{e.message}"
          routing.redirect @testators_route
        end

        # GET /testators/:testator_id
        routing.get do
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
end
