# frozen_string_literal: true

require 'roda'

module No2Date
  # Web controller for Credence API
  class App < Roda
    route('events') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @events_route = '/events'

        routing.on(String) do |evnt_id|
          @event_route = "#{@events_route}/#{evnt_id}"

          # GET /events/[evnt_id]
          routing.get do
            evnt_info = GetEvent.new(App.config).call(
              @current_account, evnt_id
            )
            event = Event.new(evnt_info)

            view :event, locals: {
              current_account: @current_account, event:
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Event not found'
            routing.redirect @events_route
          end
        end

        # GET /events/
        routing.get do
          event_list = GetAllEvents.new(App.config).call(@current_account)

          events = Events.new(event_list)

          view :events_all,
               locals: { current_account: @current_account, events: }
        end

        # POST /events/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?

          evnt_params = routing.params
          # Convert datetime-local input to required format
          if evnt_params['start_datetime'] && evnt_params['end_datetime']
            time_zone = "Asia/Taipei"  # You can adjust this to your desired time zone
            evnt_params['start_datetime'] = Time.parse(evnt_params['start_datetime']).in_time_zone(time_zone).strftime("%Y-%m-%d %H:%M:%S %z")
            evnt_params['end_datetime'] = Time.parse(evnt_params['end_datetime']).in_time_zone(time_zone).strftime("%Y-%m-%d %H:%M:%S %z")
          end
          # puts "EVNT: #{evnt_params}"

          event_data = Form::NewEvent.new.call(routing.params)
          if event_data.failure?
            flash[:error] = Form.message_values(event_data)
            routing.halt
          end

          CreateNewEvent.new(App.config).call(
            current_account: @current_account,
            event_data: event_data.to_h
          )

          flash[:notice] = 'Event created successfully'
        rescue StandardError => e
          puts "FAILURE Creating Event: #{e.inspect}"
          flash[:error] = 'Could not create event'
        ensure
          routing.redirect @events_route
        end
      end
    end
  end
end
