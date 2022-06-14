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

    # This function will associate with two variables
    #  1: the session of breadcrumb (will be set in the logic)
    #  2: the presentation directory to show in 'view' (will be returned to the caller)
    #  There are 3 way to use the function
    #     1) get_view_path(breadcrumb: "path1/path2")
    #     --- the breadcrumb associates to directory "presentation/path1/path2.slim"
    #     --- when a slim file and breadcrumb are in the same order
    #     2) get_view_path(breadcrumb: "path1", in_page: "path1")
    #     --- the breadcrumb does not associate to the directory, such as "presentation/path1/path1.slim"
    #     --- in_page is specified to not duplicate the breadcrumb
    #     3) get_view_path(breadcrumb: "/path1/path2", display: "display information")
    #     --- the breadcrumb associates to directory "presentation/path1/path2.slim"
    #     --- but there is information that needs to be showed before the main path
    #     --- breadcrumb will insert display before the last path "/path1/{display information}/path2"
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
