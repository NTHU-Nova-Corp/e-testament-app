# frozen_string_literal: true

require 'roda'
require 'google/apis/oauth2_v2'

require_relative './app'

module ETestament
  # Web controller for ETestament APP
  # rubocop:disable Metrics/ClassLength
  class App < Roda
    def gg_oauth_url(config)
      client = Signet::OAuth2::Client.new({
                                            client_id: config.GOOGLE_API_CLIENT_ID,
                                            client_secret: config.GOOGLE_API_CLIENT_SECRET,
                                            authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
                                            scope: [Google::Apis::Oauth2V2::AUTH_USERINFO_PROFILE,
                                                    Google::Apis::Oauth2V2::AUTH_USERINFO_EMAIL],
                                            redirect_uri: "#{request.base_url}/auth/google_callback"
                                          })
      client.authorization_uri.to_s
    end

    # rubocop:disable Metrics/BlockLength
    route('auth') do |routing|
      @signin_route = '/auth/signin'
      routing.is 'signin' do
        # GET /auth/signin
        # Gets the sign in view
        routing.get do
          view :signin, locals: {
            gg_oauth_url: gg_oauth_url(App.config).to_s
          }
        end

        # POST /auth/signin
        # Sends a sign in request to the api
        routing.post do
          credentials = Form::LoginCredentials.new.call(routing.params)

          if credentials.failure?
            flash[:error] = 'Please enter both username and password.'
            routing.redirect @signin_route
          end

          current_account = Services::Accounts::SignInInternal.new(App.config, session)
                                                              .call(**credentials.values)
          flash[:notice] = "Welcome back #{current_account.username}!"
          routing.redirect '/'
        rescue Exceptions::UnauthorizedError, Exceptions::BadRequestError => e
          flash.now[:error] = "Error: #{e.message}"
          response.status = e.instance_variable_get(:@status_code)
          view :signin, locals: {
            gg_oauth_url: gg_oauth_url(App.config).to_s
          }
        end
      end

      @oauth_callback = '/auth/google_callback'
      routing.on 'google_callback' do
        client = Signet::OAuth2::Client.new({
                                              client_id: App.config.GOOGLE_API_CLIENT_ID,
                                              client_secret: App.config.GOOGLE_API_CLIENT_SECRET,
                                              token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                                              redirect_uri: "#{request.base_url}/auth/google_callback",
                                              code: routing.params['code']
                                            })

        sso_response = client.fetch_access_token!
        session[:access_token] = sso_response['access_token']
        current_account = Services::Accounts::SignInGoogleAccount.new(App.config, session).call(
          access_token: sso_response['access_token']
        )
        Models::CurrentSession.new(session).current_account = current_account

        flash[:notice] = "Welcome #{current_account.username}!"

        # GET /auth/google_callback
        routing.get do
          routing.redirect "/#{routing['state']}"
        end
      rescue Exceptions::UnauthorizedError => e
        flash.now[:error] = "Error: #{e.message}"
        response.status = e.instance_variable_get(:@status_code)
        view :signin, locals: {
          gg_oauth_url: gg_oauth_url(App.config).to_s
        }
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

          rescue Exceptions::BadRequestError => e
            flash.now[:error] = "Error: #{e.message}"
            response.status = e.instance_variable_get(:@status_code)
            view :signin, locals: {
              gg_oauth_url: gg_oauth_url(App.config).to_s
            }
          end

          # POST /auth/signup/:register_token
          routing.post do
            passwords = Form::Passwords.new.call(routing.params)
            raise Form.message_values(passwords) if passwords.failure?

            Services::Accounts::SignUp.new(App.config)
                                      .call(
                                        registration_token:,
                                        first_name: routing.params['first_name'],
                                        last_name: routing.params['last_name'],
                                        password: passwords['password']
                                      )

            flash[:notice] = 'Account created! Please login'
            routing.redirect '/auth/signin'

          rescue Exceptions::BadRequestError => e
            flash.now[:error] = "Error: #{e.message}"
            response.status = e.instance_variable_get(:@status_code)
            routing.redirect '/auth/signin'
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
          registration = Form::Registration.new.call(routing.params)

          if registration.failure?
            flash[:error] = Form.validation_errors(registration)
            routing.redirect @signup_route
          end

          # account_data = JsonRequestBody.symbolize(routing.params)
          Services::Accounts::SendConfirmationEmail.new(App.config)
                                                   .call(registration_data: JsonRequestBody.symbolize(routing.params))
          flash[:notice] = 'Please check your email for a verification link'
          routing.redirect '/'

        rescue Exceptions::BadRequestError => e
          response.status = e.instance_variable_get(:@status_code)
          flash[:error] = "Error: #{e.message}"
          routing.redirect @signup_route
        # TODO: Create new error handler for invalid input
        rescue StandardError => e
          App.logger.error "Could not verify registration: #{e.inspect}"
          flash[:error]
        end
      end

      @signout_route = '/auth/signout'
      routing.on 'signout' do
        routing.get do
          Services::Accounts::SignOut.new(session).call
          flash[:notice] = "You've been logged out"

          routing.redirect @signin_route
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/ClassLength
end
