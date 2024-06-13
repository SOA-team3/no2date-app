# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Event
    attr_reader :id, :title, :description, :location, :start_datetime, :end_datetime,
                :is_google, :is_flexible,
                :account # full details

    def initialize(info)
      # puts "No2Date/models Event info: #{info}"
      process_attributes(info['attributes'])
      process_created(info['created'])
    end

    def process_attributes(attributes)
      @id = attributes['id']
      @title = attributes['title']
      @description = attributes['description']
      @location = attributes['location']
      @start_datetime = attributes['start_datetime']
      @end_datetime = attributes['end_datetime']
      @is_google = attributes['is_google']
      @is_flexible = attributes['is_flexible']
    end

    def process_created(created)
      @account = Account.new(created['account'])
    end
  end
end
