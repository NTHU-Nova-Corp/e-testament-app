# frozen_string_literal: true

require 'roda'
require_relative './app'

module ETestament
  # Web controller for ETestament API
  class App < Roda
    route('heirs') do |routing|
      @heirs_route = '/heirs'
      if @current_account.logged_in?
        # GET /heirs
        routing.get do
          dir_path = get_view_path('heirs', 'heirs')
          relations = Services::Heirs::GetRelations.new(App.config).call(current_account: @current_account)
          heirs = Services::Heirs::GetAll.new(App.config).call(current_account: @current_account)
          view dir_path, locals: { current_account: @current_account, heirs:, relations: }
        end

        # POST /heirs
        routing.post do
          new_heir = JsonRequestBody.symbolize(routing.params)
          # first_name:, last_name:, email:, relation_id
          Services::Heirs::Create.new(App.config).call(current_account: @current_account, **new_heir)

          flash[:notice] = 'Heir has been created!'
          routing.redirect '/heirs'
        rescue Exceptions::BadRequestError => e
          flash.now[:error] = "Error: #{e.message}"
          response.status = e.instance_variable_get(:@status_code)
          routing.halt
        end
      else
        routing.redirect '/auth/signin'
      end
    end
  end
end
