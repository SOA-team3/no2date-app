# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Meeting
    attr_reader :id, :name, :description, :organizer, :attendees

    def initialize(meet_info)
      @id = meet_info['attributes']['id']
      @name = meet_info['attributes']['name']
      @description = meet_info['attributes']['description']
      @organizer = meet_info['attributes']['organizer']
      @attendees = meet_info['attributes']['attendees']
    end
  end
end
