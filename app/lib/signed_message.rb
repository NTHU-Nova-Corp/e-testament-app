# frozen_string_literal: true

require 'rbnacl'
require 'base64'

# Encrypt-Decrypt from DB
class SignedMessage
  # Call setup once to pass in config variable with SIGNING_KEY attribute
  def self.setup(config)
    @signing_key = Base64.strict_decode64(config.SIGNING_KEY)
  end

  def self.sign(message)
    signature = RbNaCl::SigningKey.new(@signing_key)
                                  .sign(message.to_json)
                                  .then { |sig| Base64.strict_encode64(sig) }

    { data: message, signature: }
  end
end
