# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('testament') do |routing|
      @testament_route = '/testament'
      @testaments_dir = 'testament'

      routing.redirect '/auth/signin' unless @current_account.logged_in?

      # POST /testament/complete
      routing.post 'complete' do
        Services::Testament::Get.new(App.config).call(current_account: @current_account)

        flash[:notice] = 'Testament completed!'
      rescue Exceptions::BadRequestError => e
        flash[:error] = "Error: #{e.message}"
      ensure
        routing.redirect @testament_route
      end

      # GET /testament
      routing.get do
        dir_path = get_view_path(breadcrumb: 'testament', in_page: 'testament')
        properties = Services::Testament::Get.new(App.config).call(current_account: @current_account)

        view dir_path, locals: { properties: }
      end
    end
  end
end
