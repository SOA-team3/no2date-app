# frozen_string_literal: true

require_relative 'form_base'

module No2Date
  module Form
    # Form verifying Participant Email
    class ParticipantEmail < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/account_details.yml')

      params do
        required(:email).filled(format?: EMAIL_REGEX)
      end
    end
  end
end
