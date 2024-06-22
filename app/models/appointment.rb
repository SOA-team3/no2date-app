# frozen_string_literal: true

module No2Date
  # Behaviors of the currently logged in account
  class Appointment
    attr_reader :id, :name, :description, # basic info
                :owner, :participants, :events_under_appointment, :free_time_of_appointment, :policies # full details

    def initialize(appt_info)
      process_attributes(appt_info['attributes'])
      process_relationships(appt_info['relationships'])
      process_events_under_appointment(appt_info['events_under_appointment'])
      process_free_time_of_appointment(appt_info['free_time_of_appointment'])
      process_policies(appt_info['policies'])
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

    def process_free_time_of_appointment(free_time_of_appointment)
      return nil unless free_time_of_appointment

      @free_time_of_appointment = free_time_of_appointment
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end
  end
end
