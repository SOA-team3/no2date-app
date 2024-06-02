# frozen_string_literal: true

require 'roda'

module No2Date
  # Web controller for Credence API
  class App < Roda
    route('schedules') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @schedules_route = '/schedules'

        routing.on(String) do |sched_id|
          @schedule_route = "#{@schedules_route}/#{sched_id}"

          # GET /schedules/[sched_id]
          routing.get do
            sched_info = GetSchedule.new(App.config).call(
              @current_account, sched_id
            )
            schedule = Schedule.new(sched_info)

            view :schedule, locals: {
              current_account: @current_account, schedule: schedule
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Schedule not found'
            routing.redirect @schedules_route
          end
        end

        # GET /schedules/
        routing.get do
            schedule_list = GetAllSchedules.new(App.config).call(@current_account)

            schedules = Schedules.new(schedule_list)

            view :schedules_all,
                 locals: { current_account: @current_account, schedules: }
        end

        # POST /schedules/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          puts "SCHED: #{routing.params}"
          schedule_data = Form::NewSchedule.new.call(routing.params)
          if schedule_data.failure?
            flash[:error] = Form.message_values(schedule_data)
            routing.halt
          end

          CreateNewSchedule.new(App.config).call(
            current_account: @current_account,
            schedule_data: schedule_data.to_h
          )

          flash[:notice] = 'Schedule created successfully'
        rescue StandardError => e
          puts "FAILURE Creating Schedule: #{e.inspect}"
          flash[:error] = 'Could not create schedule'
        ensure
          routing.redirect @schedules_route
        end
      end
    end
  end
end
