# frozen_string_literal: true

require 'roda'
require 'slim'

module ETestament
  # Base class for ETestament Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash

    route do |routing|
      update_breadcrumb_session(nil)
      response['Content-Type'] = 'text/html; charset=utf-8'
      # @current_account = session[:current_account]
      @current_account = SecureSession.new(session).get(:current_account)
      @current_route = routing.instance_variable_get(:@remaining_path)
      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        view :home, locals: { current_account: @current_account }
      end
    end

    def update_breadcrumb_session(breadcrumb)
      if breadcrumb.nil?
        session[:breadcrumb] = nil
        @breadcrumb = nil
      else
        session[:breadcrumb] = breadcrumb
        @breadcrumb = session[:breadcrumb].split('/')
      end
    end
  end
end
