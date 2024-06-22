# frozen_string_literal: true

require 'http'

# Returns all appointments belonging to an account
class GetAllAppointments
  def initialize(config)
    @config = config
  end

  def call(current_account)
    response = HTTP.auth("Bearer #{current_account.auth_token}")
                   .get("#{@config.API_URL}/appointments")

    response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
  end
end
