# app/services/json_web_token.rb
class JsonWebToken
  # This is the secret used to sign JWT tokens
  # Rails generates secret_key_base automatically
  # Keeps tokens tamper-proof
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue
    nil
  end
end




# h = { "user_id" => 1 }

# h["user_id"]  # => 1
# h[:user_id]   # => nil ❌
#
# This is annoying when:

# - JSON parsing gives string keys

# - Your code expects symbol keys


# What HashWithIndifferentAccess does

# It lets you access keys using either strings or symbols.

# h = HashWithIndifferentAccess.new({ "user_id" => 1 })

# h["user_id"]  # => 1
# h[:user_id]   # => 1 ✅


# Internally, it normalizes keys (stores them as strings).
