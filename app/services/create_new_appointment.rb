# frozen_string_literal: true

require 'http'

module No2Date
  # Create a new appointment for an account
  class CreateNewAppointment
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, appointment_data:)
      config_url = "#{api_url}/appointments"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: appointment_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
