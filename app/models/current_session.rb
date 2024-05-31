# frozen_string_literal: true

require_relative 'account'

module No2Date
  # Managing session information
  class CurrentSession
    def initialize(session)
      @secure_session = SecureSession.new(session)
    end

    def current_account
      Account.new(@secure_session.get(:account),
                  @secure_session.get(:auth_token))
    end

    def current_account=(current_account)
      puts "current_session.rb 2 #{current_account.account_info}"
      @secure_session.set(:account, current_account.account_info)
      @secure_session.set(:auth_token, current_account.auth_token)
    end

    def delete
      @secure_session.delete(:account)
      @secure_session.delete(:auth_token)
    end
  end
end
