# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Meeting
    attr_reader :id, :name, :description, :organizer, :attendees, # basic info
                :owner, :attenders, :schedules_under_meeting, :policies # full details

    def initialize(_meet_info)
      process_attributes(proj_info['attributes'])
      process_relationships(proj_info['relationships'])
      process_schedules_under_meeting(proj_info['schedules_under_meeting'])
      # process_available_meettime
      process_policies(proj_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @description = attributes['description']
      @organizer = attributes['organizer']
      @attendees = attributes['attendees']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @attenders = process_attenders(relationships['attenders'])
    end

    def process_attenders(attenders)
      return nil unless attenders

      attenders.map { |account_info| Account.new(account_info) }
    end

    def process_schedules_under_meeting(schedules_under_meeting)
      return nil unless schedules_under_meeting

      # @schedules_under_meeting = schedules_under_meeting.map { |schedule| Schedule.new(account_info) }
      @schedules_under_meeting = schedules_under_meeting
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end
  end
end
