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

          SecureSession.new(session).set(:current_account, account)
          flash[:notice] = "Welcome back #{account['username']}!"
          routing.redirect '/'
        rescue AuthenticateAccount::UnauthorizedError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :login
        rescue AuthenticateAccount::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @signin_route
        end
      end

      @signup_route = '/auth/signup'
      routing.on 'signup' do
        routing.get do
          view :signup, locals: { password_conditions: ETestament::PasswordCondition.new.list }
        end

        routing.post do
          SignUpNewAccount.new(App.config).call(
            username: routing.params['username'],
            first_name: routing.params['first_name'],
            last_name: routing.params['last_name'],
            email: routing.params['email'],
            password: routing.params['password']
          )

          account = AuthenticateAccount.new(App.config).call(
            username: routing.params['username'],
            password: routing.params['password']
          )

          SecureSession.new(session).set(:current_account, account)
          flash[:notice] = "Sign up success! Welcome to E-Testament #{account['username']}!"
          routing.redirect '/'
        rescue StandardError => e
          App.logger.error "ERROR CREATING ACCOUNT: #{e.inspect}"
          App.logger.error e.backtrace
          flash[:error] = 'Could not create account'
          routing.redirect @signup_route
        end
      end

      @signout_route = '/auth/signout'
      routing.on 'signout' do
        routing.get do
          SecureSession.new(session).delete(:current_account)
          flash[:notice] = "You've been logged out"
          routing.redirect @signin_route
        end
      end
    end
  end
end
