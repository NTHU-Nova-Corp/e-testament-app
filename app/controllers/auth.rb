# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('auth') do |routing|
      @signin_route = '/auth/signin'
      routing.is 'signin' do
        # GET /auth/signin
        routing.get do
          view :signin
        end

        # POST /auth/signin
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            username: routing.params['username'],
            password: routing.params['password']
          )

          session[:current_account] = account
          flash[:notice] = "Welcome back #{account['username']}!"
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :signin
        end
      end

      routing.on 'signout' do
        routing.get do
          session[:current_account] = nil
          routing.redirect @signin_route
        end
      end
    end
  end
end
