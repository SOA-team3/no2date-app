# frozen_string_literal: true

module No2Date
  # Service to add participant to project
  class AddParticipant
    class ParticipantNotAdded < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, participant:, appointment_id:)
      puts "add_participant.rb #{participant.inspect}"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/appointments/#{appointment_id}/participants",
                          json: { email: participant[:email] })

      raise ParticipantNotAdded unless response.code == 200
    end
  end
end
