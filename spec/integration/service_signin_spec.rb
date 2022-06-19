# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

# Mock config
class Config
  def API_URL
    API_URL
  end
end

describe 'Test Service Objects' do

  before do
    @credentials = { username: 'daniel.kong', password: 'mypa$$w0rd3' }
    @mal_credentials = { username: 'daniel.kong', password: 'wrongpassword' }
    @api_account = { username: 'daniel.kong', email: 'daniel.kong@mail.com' }
  end

  after do
    WebMock.reset!
  end

  config = Config.new
  session = {}

  describe 'Find authenticated account' do

    it 'HAPPY: should find an authenticated account' do
      auth_account_file = 'spec/fixtures/auth_account.json'

      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth = ETestament::Services::Accounts::SignInInternal.new(config, session).call(**@credentials)
      account = auth.account_info
      _(account).wont_be_nil
      _(account['username']).must_equal @api_account[:username]
      _(account['email']).must_equal @api_account[:email]
    end

    it 'BAD: should not find a false authenticated account' do
      config = Config.new
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@mal_credentials))
             .to_return(body: { message: 'fail' }.to_json, status: 401)
      _(proc {
        ETestament::Services::Accounts::SignInInternal.new(config, session).call(
          username: @mal_credentials[:username], password: @mal_credentials[:password])
      }).must_raise ETestament::Exceptions::UnauthorizedError
    end
  end
end
