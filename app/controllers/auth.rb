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
          view :signin
        rescue AuthenticateAccount::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @signin_route
        end
      end

      @signup_route = '/auth/register'
      routing.is 'register' do

        # GET /auth/register
        routing.get do
          view :register
        end

        # POST /auth/register
        routing.post do
          account_data = JsonRequestBody.symbolize(routing.params)
          VerifyRegistration.new(App.config).verify(account_data)

          flash[:notice] = 'Please check your email for a verification link'
          routing.redirect '/'
        rescue VerifyRegistration::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          routing.redirect @register_route
        rescue StandardError => e
          App.logger.error "Could not verify registration: #{e.inspect}"
          flash[:error] = 'Registration details are not valid'
          routing.redirect @register_route
        end
      end

      @signup_route = '/auth/signup'
      routing.on 'signup' do
        routing.get(String)  do |registration_token|
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          new_account = SecureMessage.decrypt(registration_token)

          view :signup,
               locals: {
                 password_conditions: ETestament::PasswordCondition.new.list,
                 new_account:,
                 registration_token:
               }
        end

        routing.post do
          register_token = routing.params['register_token']
          new_account = SecureMessage.decrypt(register_token)

          SignUpNewAccount.new(App.config).call(
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
        rescue SignUpNewAccount::InvalidAccount => e
          flash[:error] = e.message
          routing.redirect '/auth/register'
        rescue StandardError => e
          flash[:error] = e.message
          routing.redirect(
            "#{App.config.APP_URL}/auth/register/#{registration_token}"
          )
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
    # rubocop:enable Metrics/BlockLength
  end
end
