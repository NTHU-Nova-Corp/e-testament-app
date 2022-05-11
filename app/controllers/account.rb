# frozen_string_literal: true

require 'roda'
require_relative './app'
require_relative '../instances/password_conditions'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('account') do |routing|
      routing.on 'signup' do
        routing.get do
          view :signup, locals: { password_conditions: ETestament::PasswordCondition.new.list }
        end

        routing.post do
          account = SignUpNewAccount.new(App.config).call(
            username: routing.params['username'],
            first_name: routing.params['first_name'],
            last_name: routing.params['last_name'],
            email: routing.params['email'],
            password: routing.params['password']
          )

          session[:current_account] = account
          flash[:notice] = "Sign up success! Welcome to E-Testament #{account['username']}!"
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :signup
        end
      end

      routing.on do
        # GET /account/signin
        routing.get String do |username|
          if @current_account && @current_account['username'] == username
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/signin'
          end
        end
      end
    end
  end
end
