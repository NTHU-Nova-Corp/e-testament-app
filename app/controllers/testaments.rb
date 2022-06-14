# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('testament') do |routing|
      @testaments_route = '/testament'
      @testaments_dir = 'testament'

      routing.redirect '/auth/signin' unless @current_account.logged_in?

      # GET /testaments
      routing.get do
        dir_path = get_view_path(breadcrumb: 'testament', in_page: 'testament')
        properties = Services::Testament::Get.new(App.config).call(current_account: @current_account)

        view dir_path, locals: { properties: }
      end
    end
  end
end
