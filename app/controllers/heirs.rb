# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('heirs') do |routing|
      routing.on do
        # GET /heir
        routing.get do
          heirs = Heirs.new(App.config).all(session[:current_account]['id'])
          view 'heirs/heirs', locals: { heirs: }
        end
      end
    end
  end
end

