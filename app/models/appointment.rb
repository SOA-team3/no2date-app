# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Appointment
    attr_reader :id, :name, :description, # basic info
                :owner, :participants, :events_under_appointment, :policies # full details

    def initialize(evnt_info)
      process_attributes(evnt_info['attributes'])
      process_relationships(evnt_info['relationships'])
      process_events_under_appointment(evnt_info['events_under_appointment'])
      # process_available_meettime
      process_policies(evnt_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @description = attributes['description']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @participants = process_participants(relationships['participants'])
    end

    def process_participants(participants)
      return nil unless participants

      participants.map { |account_info| Account.new(account_info) }
    end

    def process_events_under_appointment(events_under_appointment)
      return nil unless events_under_appointment

      # @events_under_appointment = events_under_appointment.map { |event| Event.new(account_info) }
      @events_under_appointment = events_under_appointment
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end
  end
end
