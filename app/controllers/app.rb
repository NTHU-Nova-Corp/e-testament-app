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
      get_view_path(breadcrumb: nil)
      response['Content-Type'] = 'text/html; charset=utf-8'
      @current_account = Models::CurrentSession.new(session).current_account
      @current_route = routing.instance_variable_get(:@remaining_path)

      begin
        @request_testator = Services::Testators::GetReceivedRequest.new(App.config).call(current_account: @current_account)
      rescue StandardError
        @request_testator = Models::Testator.new(nil)
      end

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        view :home
      end

    rescue Exceptions::ApiServerError => e
      App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
      flash[:error] = e.message
      response.status = e.instance_variable_get(:@status_code)
      routing.redirect '/'
    end

    def get_view_path(breadcrumb:, in_page: nil, display: nil)
      if breadcrumb.nil?
        session[:breadcrumb] = nil
        @breadcrumb = nil
      else
        split_breadcrumb = breadcrumb.split('/')
        split_breadcrumb.insert(split_breadcrumb.length - 1, display) unless display.nil?

        session[:breadcrumb] = split_breadcrumb
        @breadcrumb = split_breadcrumb
      end
      in_page.nil? ? breadcrumb : "#{breadcrumb}/#{in_page}"
    end
  end
end
