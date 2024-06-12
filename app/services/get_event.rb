# frozen_string_literal: true

require 'http'

module No2Date
  # Returns all events belonging to an account
  class GetEvent
    def initialize(config)
      @config = config
    end

    def call(current_account, evnt_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                    .get("#{@config.API_URL}/events/#{evnt_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end