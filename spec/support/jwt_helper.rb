module JwtHelper
    def generate_jwt_token(user)
      subject = "#{user.id}"
      payload = { sub: subject, jti: user.jti, exp: 24.hours.from_now.to_i }
      JWT.encode(payload, Rails.application.credentials.fetch(:secret_key_base))
    end
end