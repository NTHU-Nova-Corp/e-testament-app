# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    # rubocop:disable Metrics/BlockLength
    route('auth') do |routing|
      @signin_route = '/auth/signin'
      routing.is 'signin' do
        # GET /auth/signin
        # Gets the sign in view
        routing.get do
          view :signin
        end

        # POST /auth/signin
        # Sends a sign in request to the api
        routing.post do
          account_info = Services::Account.new(App.config).signin(
            username: routing.params['username'],
            password: routing.params['password']
          )

          current_account = Models::Account.new(
            account_info[:account],
            account_info[:auth_token]
          )

          Models::CurrentSession.new(session).current_account = current_account
          flash[:notice] = "Welcome back #{current_account.username}!"
          routing.redirect '/'
        rescue Services::Account::UnauthorizedError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :signin
        rescue Services::Account::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @signin_route
        end
      end

      @signup_route = '/auth/signup'
      routing.on 'signup' do
        routing.on String do |registration_token|
          # GET /auth/signup/:register_token
          routing.get do
            flash.now[:notice] = 'Email Verified! Please choose a new password'
            new_account = SecureMessage.decrypt(registration_token)

            view :signup,
                 locals: {
                   password_conditions: ETestament::PasswordCondition.new.list,
                   new_account:,
                   registration_token:
                 }
          end

          # POST /auth/signup/:register_token
          routing.post do
            new_account = SecureMessage.decrypt(registration_token)

            Services::Account.new(App.config).signup(
              username: new_account['username'],
              first_name: routing.params['first_name'],
              last_name: routing.params['last_name'],
              email: new_account['email'],
              password: routing.params['password']
            )

            # AuthenticateAccount.new(App.config).call(
            #   username: routing.params['username'],
            #   password: routing.params['password']
            # )

            flash[:notice] = 'Account created! Please login'
            routing.redirect '/auth/signin'
          rescue StandardError => e
            flash[:error] = e.message
            routing.redirect '/auth/signup'
          end
        end

        # GET /auth/signup
        # Gets the signup first step view
        routing.get do
          view :signup_onboard
        end

        # POST /auth/signup
        # Post the basic registration request to the api so the api can send the
        # registration token via email
        routing.post do
          account_data = JsonRequestBody.symbolize(routing.params)
          Services::Account.new(App.config).send_email_confirmation(account_data)

          flash[:notice] = 'Please check your email for a verification link'
          routing.redirect '/'
        rescue Services::Account::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          routing.redirect @register_route
        rescue StandardError => e
          App.logger.error "Could not verify registration: #{e.inspect}"
          flash[:error] = 'Registration details are not valid'
          routing.redirect @register_route
        end
      end

      @signout_route = '/auth/signout'
      routing.on 'signout' do
        routing.get do
          Models::CurrentSession.new(session).delete
          flash[:notice] = "You've been logged out"
          routing.redirect @signin_route
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
