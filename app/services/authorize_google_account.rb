# frozen_string_literal: true

require 'http'
require 'uri'
require 'sinatra'
require 'httparty'

module No2Date
  # Returns an authenticated user, or nil
  class AuthorizeGoogleAccount
    # Errors emanating from Google
    class UnauthorizedError < StandardError
      def message
        'Could not login with Google'
      end
    end

    def initialize(config)
      @config = config
    end

    def call(code)
      get_access_token_from_google(code)
      get_sso_account_from_api
    end

    private

    def get_access_token_from_google(code)
      # challenge_response =
      #   HTTP.headers(accept: 'application/json')
      #       .post(@config.GOOG_TOKEN_URL,
      #             form: { client_id: @config.GOOG_CLIENT_ID,
      #                     client_secret: @config.GOOG_CLIENT_SECRET,
      #                     code: code })
      # raise UnauthorizedError unless challenge_response.status < 400

      # JSON.parse(challenge_response)['access_token']
      # Assuming the code is passed as a query parameter to the callback URL

      options = {
        body: URI.encode_www_form({
                                    code:,
                                    client_id: @config.GOOG_CLIENT_ID,          # Ensure you have defined `client_id`
                                    client_secret: @config.GOOG_CLIENT_SECRET,  # Ensure you have defined `client_secret`
                                    redirect_uri: @config.REDIRECT_URI, # Ensure you define or replace `redirect_url` with your actual URL
                                    grant_type: 'authorization_code'
                                  }),
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
      }

      url = 'https://oauth2.googleapis.com/token'
      response = HTTParty.post(url, options)

      # Parsing the JSON response to access tokens
      @access_token = response.parsed_response['access_token']
      @id_token = response.parsed_response['id_token']
    end

    def get_sso_account_from_api
      signed_sso_info = { access_token: @access_token, id_token: @id_token }
                        .then { |sso_info| SignedMessage.sign(sso_info) }

      response = HTTP.post(
        "#{@config.API_URL}/auth/sso",
        json: signed_sso_info
      )

      JSON.parse(response)['data']['attributes']

      account_info = JSON.parse(response)['data']['attributes']

      {
        account: account_info['account'],
        auth_token: account_info['auth_token']
      }
    end
  end
end
