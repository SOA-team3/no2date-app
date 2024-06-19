# frozen_string_literal: true

require 'roda'

module No2Date
  # Web controller for No2Date API
  class App < Roda
    route('appointments') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @appointments_route = '/appointments'

        routing.on(String) do |appt_id|
          @appointment_route = "#{@appointments_route}/#{appt_id}"

          # GET /appointments/[appt_id]
          routing.get do
            puts "appointments.rb GET /appointments/#{appt_id}"
            appt_info = GetAppointment.new(App.config).call(
              @current_account, appt_id
            )
            puts "appointments.rb appt_info: #{appt_info.inspect}"
            appointment = Appointment.new(appt_info)

            puts "appointments.rb appointment: #{appointment.inspect}"

            view :appointment, locals: {
              current_account: @current_account, appointment:
            }
          rescue StandardError => e
            App.logger.error "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Appointment not found'
            routing.redirect @appointments_route
          end

          # POST /appointments/[appt_id]/participants
          routing.post('participants') do
            puts "appointments.rb POST /appointments/#{appt_id}/participants"
            action = routing.params['action']
            puts "appointments.rb action: #{action}"
            puts "appointments.rb routing.params: #{routing.params}"
            participant_info = Form::ParticipantEmail.new.call(routing.params)
            puts "appointments.rb participant_info: #{participant_info.inspect}"
            if participant_info.failure?
              flash[:error] = Form.validation_errors(participant_info)
              routing.halt
            end
            puts "appointments.rb participant_info: #{participant_info.failure?}"

            task_list = {
              'add' => { service: AddParticipant,
                         message: 'Added new participant to project' },
              'remove' => { service: RemoveParticipant,
                            message: 'Removed participant from project' }
            }

            puts "appointments.rb after task_list"
            puts "appointments.rb task_list: #{task_list}"

            task = task_list[action]
            puts "appointments.rb task: #{task}"
            task[:service].new(App.config).call(
              current_account: @current_account,
              participant: participant_info,
              appointment_id: appt_id
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find participant'
          ensure
            routing.redirect @appointment_route
          end
        end

        # GET /appointments/
        routing.get do
          appointment_list = GetAllAppointments.new(App.config).call(@current_account)

          appointments = Appointments.new(appointment_list)

          view :appointments_all,
               locals: { current_account: @current_account, appointments: }
        end

        # POST /appointments/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          puts "APPT: #{routing.params}"
          appointment_data = Form::NewAppointment.new.call(routing.params)
          if appointment_data.failure?
            flash[:error] = Form.message_values(appointment_data)
            routing.halt
          end

          CreateNewAppointment.new(App.config).call(
            current_account: @current_account,
            appointment_data: appointment_data.to_h
          )

          flash[:notice] = 'Add participants to your new appointment'
        rescue StandardError => e
          App.logger.error "FAILURE Creating Appointment: #{e.inspect}"
          flash[:error] = 'Could not create appointment'
        ensure
          routing.redirect @appointments_route
        end
      end
    end
  end
end
