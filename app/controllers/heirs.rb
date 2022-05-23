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
          dir_path = get_view_path('heirs', 'heirs')
          relations = Services::Heirs.new(App.config).relations
          heirs = Services::Heirs.new(App.config).all(@current_account)
          view dir_path, locals: { current_user: @current_account, heirs:, relations: }
        end

        # POST /heirs
        routing.post do
          new_heir = JsonRequestBody.symbolize(routing.params)
          # first_name:, last_name:, email:, relation_id
          Services::Heirs.new(App.config).create(@current_account, **new_heir)

          flash[:notice] = 'Heir has been created!'
          routing.redirect '/heirs'
        end
      else
        routing.redirect '/auth/signin'
      end
    end
  end
end
