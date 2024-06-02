# frozen_string_literal: true

require_relative 'form_base'

module No2Date
  module Form
    class NewMeeting < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_meeting.yml')

      params do
        required(:name).filled
        optional(:description).maybe(:string)
      end
    end
  end
end
