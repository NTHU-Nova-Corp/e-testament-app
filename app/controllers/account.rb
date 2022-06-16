# frozen_string_literal: true

require 'roda'
require_relative './app'
require_relative '../instances/password_conditions'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('account') do |routing|
      routing.on do

        routing.on 'executor' do
          routing.on String do |executor_email|
            routing.post 'cancel' do
              Services::Executors::CancelExecutorRequest.new(App.config).call(current_account: @current_account,
                                                                              executor_email:)

              flash[:notice] = "The request to #{executor_email} has been cancelled"
              routing.redirect "/account/#{@current_account.username}"
            end

            routing.post 'unassign' do
              Services::Executors::UnassignExecutor.new(App.config).call(current_account: @current_account,
                                                                         executor_email:)

              flash[:notice] = 'The executor has been unassigned!'
              routing.redirect "/account/#{@current_account.username}"
            end
          end

          routing.post do
            email = routing.params['assign_email']
            Services::Executors::AssignExecutor.new(App.config).call(current_account: @current_account, email:)

            flash[:notice] = "Invitation has been sent to #{email}! Please contact the person to complete the process"
            routing.redirect "/account/#{@current_account.username}"
          end
        end

        routing.get String do |username|
          routing.redirect '/auth/signin' unless @current_account.logged_in? && @current_account.username == username
          # GET executor status
          executor = Services::Executors::GetExecutor.new(App.config).call(current_account: @current_account)
          dir_path = get_view_path(breadcrumb: 'account')
          view dir_path, locals: { executor: }
        end
      end
    end
  end
end
