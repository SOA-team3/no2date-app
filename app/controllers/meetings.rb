# frozen_string_literal: true

require 'roda'

module No2Date
  # Web controller for Credence API
  class App < Roda
    route('meetings') do |routing|
      routing.on do
        # GET /meetings/
        routing.get do
          if @current_account.logged_in?
            meeting_list = GetAllMeetings.new(App.config).call(@current_account)

            meetings = Meetings.new(meeting_list)

            view :meetings_all,
                 locals: { current_user: @current_account, meetings: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
