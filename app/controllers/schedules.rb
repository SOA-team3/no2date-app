# frozen_string_literal: true

require 'roda'

module No2Date
  # Web controller for Credence API
  class App < Roda
    route('schedules') do |routing|
      routing.on do
        # GET /schedules/
        routing.get do
          if @current_account.logged_in?
            schedule_list = GetAllSchedules.new(App.config).call(@current_account)

            schedules = Schedules.new(schedule_list)

            view :schedules_all,
                 locals: { current_user: @current_account, schedules: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
