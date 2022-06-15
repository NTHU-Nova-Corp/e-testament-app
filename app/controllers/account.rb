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
          email = routing.params['assign_email']
          Services::Executors::AssignExecutor.new(App.config).call(current_account: @current_account, email:)

          flash[:notice] = "Invitation has been sent to #{email}! Please contact the person to complete the process"
          routing.redirect "/account/#{@current_account.username}"
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
