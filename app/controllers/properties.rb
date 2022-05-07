# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('properties') do |routing|
      routing.on do
        # GET /properties
        routing.get do
          view :properties, locals: {}
        end
      end
    end
  end
end

