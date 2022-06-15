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

      routing.redirect '/auth/signin' unless @current_account.logged_in?

      routing.get 'review' do
        dir_path = get_view_path(breadcrumb: 'review', in_page: 'review')

        view dir_path, locals: { testator: @request_testator, status: 'review' }
      end

      # GET /testators/:id/heirs
      routing.on String do |testator_id|

        routing.post 'reject' do
          flash[:notice] = 'The invitation has been rejected'
          dir_path = get_view_path(breadcrumb: 'review', in_page: 'review')

          view dir_path, locals: { status: 'reject' }
        end

        routing.post 'accept' do
          flash[:notice] = 'The invitation has been accepted'
          dir_path = get_view_path(breadcrumb: 'review', in_page: 'review')

          view dir_path, locals: { status: 'accept' }
        end

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

  # rubocop:enable Metrics/ClassLength
end
