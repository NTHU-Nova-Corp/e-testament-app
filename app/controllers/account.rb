# frozen_string_literal: true

require 'roda'
require_relative './app'
require_relative '../instances/password_conditions'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('account') do |routing|
      routing.on do

        routing.post 'executor' do
          assign_email = routing.params['assign_email']
          Services::Executors::AssignExecutor.new(App.config).call(current_account: @current_account, assign_email:)

          flash[:notice] = "Invitation has been sent! Please contact the person to complete the process #{assign_email}"
          routing.redirect "/account/#{@current_account.username}"
        end

        routing.get String do |username|
          routing.redirect '/auth/signin' unless @current_account.logged_in? && @current_account.username == username
          executor = Services::Executors::GetExecutor.new(App.config).call(current_account: @current_account)
          pending_executor = Services::Testators::GetPendingExecutor.new(App.config).call(current_account: @current_account)

          dir_path = get_view_path(breadcrumb: 'account')
          view dir_path, locals: { executor:, pending_executor: }
        end
      end
    end
  end
end
