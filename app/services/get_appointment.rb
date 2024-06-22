# frozen_string_literal: true

require 'http'

module No2Date
  # Returns all appointments belonging to an account
  class GetAppointment
    def initialize(config)
      @config = config
    end

    def call(current_account, appt_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/appointments/#{appt_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
