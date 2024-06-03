# frozen_string_literal: true

require_relative 'form_base'

module No2Date
  module Form
    class NewSchedule < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_schedule.yml')

      params do
        required(:title).filled(max_size?: 256)
        optional(:description).maybe(:string)
        required(:start_date).filled(format?: DATE_REGEX)
        required(:start_datetime).filled(format?: DATETIME_REGEX)
        required(:end_date).filled(format?: DATE_REGEX)
        required(:end_datetime).filled(format?: DATETIME_REGEX)
        required(:is_regular).filled(:bool)
        required(:is_flexible).filled(:bool)
      end
    end
  end
end
