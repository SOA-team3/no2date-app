# frozen_string_literal: true

require 'http'

module No2Date
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class NotAuthenticatedError < StandardError; end

    class ApiServerError < StandardError; end

    def call(username:, password:)
      credentials = { username:, password: }

      response = HTTP.post("#{ENV.fetch('API_URL', nil)}/auth/authenticate",
                           json: SignedMessage.sign(credentials))

      raise(NotAuthenticatedError) if response.code == 401
      raise(ApiServerError) if response.code != 200

      account_info = JSON.parse(response.to_s)['data']['attributes']

      { account: account_info['account'],
        auth_token: account_info['auth_token'] }
    end
  end
end
