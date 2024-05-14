# frozen_string_literal: true

require 'roda'
require_relative './app'

module No2Date
  # Web controller for No2Date API
  class App < Roda
    route('accounts') do |routing|
      routing.on do
        # GET /account/login
        routing.get String do |username|
          if @current_account && @current_account['username'] == username
            view :account, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end