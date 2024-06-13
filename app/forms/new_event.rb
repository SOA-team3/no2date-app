# frozen_string_literal: true

require_relative 'form_base'
require 'time'
require 'active_support'
require 'active_support/time'

module No2Date
  module Form
    class NewEvent < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_event.yml')

      params do
        required(:title).filled(max_size?: 256)
        optional(:location).maybe(:string)
        optional(:description).maybe(:string)
        required(:start_datetime).filled(format?: DATETIME_REGEX)
        required(:end_datetime).filled(format?: DATETIME_REGEX)
        required(:is_google).filled(:bool)
        required(:is_flexible).filled(:bool)
      end
    end
  end
end
