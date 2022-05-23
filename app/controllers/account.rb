# frozen_string_literal: true

require 'roda'
require_relative './app'
require_relative '../instances/password_conditions'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('account') do |routing|
      routing.on do
        routing.get String do |username|
          # GET /account/:username
          if @current_account.logged_in? && @current_account.username == username
            dir_path = get_view_path('account')
            view dir_path, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/signin'
          end
        end
      end
    end
  end
end
