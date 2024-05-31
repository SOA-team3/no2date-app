# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Schedule
    attr_reader :id, :title, :description, :location, :start_date, :start_datetime, :end_date, :end_datetime,
                :is_regular, :is_flexible

    def initialize(meet_info)
      @id = meet_info['attributes']['id']
      @title = meet_info['attributes']['title']
      @description = meet_info['attributes']['description']
      @location = meet_info['attributes']['location']
      @start_date = meet_info['attributes']['start_date']
      @start_datetime = meet_info['attributes']['start_datetime']
      @end_date = meet_info['attributes']['end_date']
      @end_datetime = meet_info['attributes']['end_datetime']
      @is_regular = meet_info['attributes']['is_regular']
      @is_flexible = meet_info['attributes']['is_flexible']
    end
  end
end
