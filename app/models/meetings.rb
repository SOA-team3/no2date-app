# frozen_string_literal: true

require_relative 'meeting'

module No2Date
  # Behaviors of the currently logged in account
  class Meetings
    attr_reader :all

    def initialize(meetings_list)
      @all = meetings_list.map do |meet|
        Meeting.new(meet)
      end
    end
  end
end
