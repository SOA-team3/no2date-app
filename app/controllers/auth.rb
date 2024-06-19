# frozen_string_literal: true

require 'roda'
require_relative 'app'

module No2Date
  # Web controller for No2Date APP
  class App < Roda
    def goog_oauth_url(config)
      # url = config.GOOG_OAUTH_URL
      # client_id = config.GOOG_CLIENT_ID
      # scope = config.GOOG_SCOPE

      # "#{url}?client_id=#{client_id}&scope=#{scope}"
      query = {
        'redirect_uri' => config.REDIRECT_URI,  # Ensure you define or replace `redirect_url` with your actual URL
        'client_id' => config.GOOG_CLIENT_ID,        # Replace `client_id` with your Google client ID
        'access_type' => 'offline',
        'response_type' => 'code',
        'prompt' => 'consent',
        'scope' => [
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email'
        ].join(' ')
      }
      auth_url = 'https://accounts.google.com/o/oauth2/v2/auth'
      redirect_uri = "#{auth_url}?#{URI.encode_www_form(query)}"
    end

    route('auth') do |routing|
      puts "AUTH ROUTE"
      @oauth_callback = '/auth/sso_callback'
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login, locals: {
            goog_oauth_url: goog_oauth_url(App.config)
          }
        end

        # POST /auth/login
        routing.post do
          credentials = Form::LoginCredentials.new.call(routing.params)

          if credentials.failure?
            flash[:error] = 'Please enter both username and password'
            routing.redirect @login_route
          end

          authenticated = AuthenticateAccount.new.call(**credentials.values)

          current_account = Account.new(
            authenticated[:account],
            authenticated[:auth_token]
          )

          CurrentSession.new(session).current_account = current_account

          flash[:notice] = "Welcome back #{current_account.username}!"
          routing.redirect '/appointments'
        rescue AuthenticateAccount::NotAuthenticatedError
          flash[:error] = 'Username and password did not match our records'
          response.status = 401
          routing.redirect @login_route
        rescue AuthenticateAccount::ApiServerError => e
          App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Our servers are not responding -- please try later'
          response.status = 500
          routing.redirect @login_route
        end
      end

      # routing.is 'sso_callback' do
      #   # GET /auth/sso_callback
      #   routing.get do
      #     puts "SSO CALLBACK"
      #     puts "SSO CALLBACK: #{routing.params['code']}"

      #     authorized = AuthorizeGoogleAccount
      #                  .new(App.config)
      #                  .call(routing.params['code'])

      #     current_account = Account.new(
      #       authorized[:account],
      #       authorized[:auth_token]
      #     )

      #     CurrentSession.new(session).current_account = current_account

      #     flash[:notice] = "Welcome #{current_account.username}!"
      #     routing.redirect '/appointments'
      #   rescue AuthorizeGoogleAccount::UnauthorizedError
      #     flash[:error] = 'Could not login with Google'
      #     response.status = 403
      #     routing.redirect @login_route
      #   rescue StandardError => e
      #     puts "SSO LOGIN ERROR: #{e.inspect}\n#{e.backtrace}"
      #     flash[:error] = 'Unexpected API Error'
      #     response.status = 500
      #     routing.redirect @login_route
      #   end
      # end

      @logout_route = '/auth/logout'
      routing.on 'logout' do
        # GET /auth/logout
        routing.get do
          CurrentSession.new(session).delete
          flash[:notice] = "You've been logged out"
          routing.redirect @login_route
        end
      end

      @register_route = '/auth/register'
      routing.on 'register' do
        routing.is do
          # GET /auth/register
          routing.get do
            view :register
          end

          # POST /auth/register
          routing.post do
            registration = Form::Registration.new.call(routing.params)

            if registration.failure?
              flash[:error] = Form.validation_errors(registration)
              routing.redirect @register_route
            end

            VerifyRegistration.new(App.config).call(registration)

            flash[:notice] = 'Please check your email for a verification link'
            routing.redirect '/'
          rescue VerifyRegistration::ApiServerError => e
            App.logger.warn "API server error: #{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Our servers are not responding -- please try later'
            routing.redirect @register_route
          rescue StandardError => e
            App.logger.error "Could not process registration: #{e.inspect}"
            flash[:error] = 'Registration process failed -- please contact us'
            routing.redirect @register_route
          end
        end

        # GET /auth/register/<token>
        routing.get(String) do |registration_token|
          flash.now[:notice] = 'Email verified! Please choose a new password'
          new_account = SecureMessage.decrypt(registration_token)
          view :register_confirm,
               locals: { new_account:,
                         registration_token: }
        end
      end
    end

    route('sso_callback') do |routing|
        # GET /sso_callback
        routing.get do
          puts "SSO CALLBACK"
          puts "SSO CALLBACK: #{routing.params['code']}"

          authorized = AuthorizeGoogleAccount
                       .new(App.config)
                       .call(routing.params['code'])

          current_account = Account.new(
            authorized[:account],
            authorized[:auth_token]
          )

          CurrentSession.new(session).current_account = current_account

          flash[:notice] = "Welcome #{current_account.username}!"
          routing.redirect "/" # should redirect to appointments
        rescue AuthorizeGoogleAccount::UnauthorizedError
          flash[:error] = 'Could not login with Google'
          response.status = 403
          routing.redirect @login_route
        rescue StandardError => e
          puts "SSO LOGIN ERROR: #{e.inspect}\n#{e.backtrace}"
          flash[:error] = 'Unexpected API Error'
          response.status = 500
          routing.redirect @login_route
        end
      end
  end
end
