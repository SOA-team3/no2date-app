# frozen_string_literal: true

require_relative 'event'

module No2Date
  # Behaviors of the currently logged in account
  class Events
    attr_reader :all

    def initialize(events_list)
      @all = events_list.map do |evnt|
        Event.new(evnt)
      end
    end
  end
end
