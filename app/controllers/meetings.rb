# frozen_string_literal: true

require 'roda'

module No2Date
  # Web controller for No2Date API
  class App < Roda
    route('meetings') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @meetings_route = '/meetings'

        routing.on(String) do |meet_id|
          @meeting_route = "#{@meetings_route}/#{meet_id}"

          # GET /meetings/[meet_id]
          routing.get do
            meet_info = GetMeeting.new(App.config).call(
              @current_account, meet_id
            )
            meeting = Meeting.new(meet_info)

            view :meeting, locals: {
              current_account: @current_account, meeting: meeting
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Meeting not found'
            routing.redirect @meetings_route
          end

          # POST /meetings/[meet_id]/attenders
          routing.post('attenders') do
            action = routing.params['action']
            attender_info = Form::AttenderEmail.new.call(routing.params)
            if attender_info.failure?
              flash[:error] = Form.validation_errors(attender_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddAttender,
                         message: 'Added new attendee to meeting' },
              'remove' => { service: RemoveAttender,
                            message: 'Removed attendee from meeting' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              attender: attender_info,
              meeting_id: meet_id
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find attendee'
          ensure
            routing.redirect @meeting_route
          end
        end

        # GET /meetings/
        routing.get do
            meeting_list = GetAllMeetings.new(App.config).call(@current_account)

            meetings = Meetings.new(meeting_list)

            view :meetings_all,
                 locals: { current_account: @current_account, meetings: }
        end

        # POST /meetings/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          puts "MEET: #{routing.params}"
          meeting_data = Form::NewMeeting.new.call(routing.params)
          if meeting_data.failure?
            flash[:error] = Form.message_values(meeting_data)
            routing.halt
          end

          CreateNewMeeting.new(App.config).call(
            current_account: @current_account,
            meeting_data: meeting_data.to_h
          )

          flash[:notice] = 'Add attendees to your new meeting'
        rescue StandardError => e
          puts "FAILURE Creating Meeting: #{e.inspect}"
          flash[:error] = 'Could not create meeting'
        ensure
          routing.redirect @meetings_route
        end
      end
    end
  end
end
