# frozen_string_literal: true

require_relative 'schedule'

module No2Date
  # Behaviors of the currently logged in account
  class Schedules
    attr_reader :all

    def initialize(_schedules_list)
      @all = shcedules_list.map do |sched|
        Schedule.new(sched)
      end
    end
  end
end
