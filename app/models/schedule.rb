# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Schedule
    attr_reader :id, :title, :description, :location, :start_date, :start_datetime, :end_date, :end_datetime,
                :is_regular, :is_flexible,
                :account # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_created(info['created'])
    end

    def process_attributes(attributes)
      @id = attributes['id']
      @title = attributes['title']
      @description = attributes['description']
      @location = attributes['location']
      @start_date = attributes['start_date']
      @start_datetime = attributes['start_datetime']
      @end_date = attributes['end_date']
      @end_datetime = attributes['end_datetime']
      @is_regular = attributes['is_regular']
      @is_flexible = attributes['is_flexible']
    end

    def process_created(created)
      @account = Account.new(created['account'])
    end
  end
end
