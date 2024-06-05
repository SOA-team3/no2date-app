# frozen_string_literal: true

require_relative 'appointment'

module No2Date
  # Behaviors of the currently logged in account
  class Appointments
    attr_reader :all

    def initialize(appointments_list)
      @all = appointments_list.map do |appt|
        Appointment.new(appt)
      end
    end
  end
end
