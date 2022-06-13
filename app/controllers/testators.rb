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

      # GET /testators/:id/heirs
      routing.on String do |testator_id|
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
