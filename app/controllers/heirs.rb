# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('heirs') do |routing|
      if @current_account.logged_in?
        # GET /heirs
        routing.get do
          heirs = Services::Heirs.new(App.config).all(@current_account)
          view 'heirs/heirs', locals: { current_user: @current_account, heirs: }
        end
      else
        routing.redirect '/auth/signin'
      end
    end
  end
end
