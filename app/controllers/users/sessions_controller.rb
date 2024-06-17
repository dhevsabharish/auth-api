class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :logout_current_user, only: [:create]

  def create
    super
  end

  private

  def logout_current_user
    if current_user
      current_user.update(jti: SecureRandom.uuid)
      sign_out(current_user)
    end
  end

  def respond_with(resource, _opts = {})
  if resource.present?
    token = generate_jwt_token(resource)
    MongoLogger.create(event: 'user_sign_in', user_id: resource.id, email: resource.email)
    render json: {
      message: "User signed-in successfully",
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      token: token
    }, status: :ok
  else
    head :no_content
  end
end

def respond_to_on_destroy
  if request.headers['Authorization'].present?
    begin
      jwt_payload, = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base))
      current_user = User.find(jwt_payload['sub'])
  
      if current_user.present? && current_user.jti == jwt_payload['jti']
        current_user.update(jti: SecureRandom.uuid)
        MongoLogger.create(event: 'user_sign_out', user_id: current_user.id, email: current_user.email)
        render json: { status: 200, message: "Signed out successfully" }, status: :ok
      else
        MongoLogger.create(event: 'user_sign_out_failed', message: "User has no active session")
        render json: { status: 401, message: "User has no active session" }, status: :unauthorized
      end
    rescue JWT::DecodeError
      MongoLogger.create(event: 'user_sign_out_failed', message: "Invalid token")
      render json: { status: 401, message: "Invalid token" }, status: :unauthorized
    end
  else
    MongoLogger.create(event: 'user_sign_out_failed', message: "Authorization header missing")
    render json: { status: 401, message: "Authorization header missing" }, status: :unauthorized
  end
end

  def generate_jwt_token(user)
    subject = "#{user.id}"
    payload = { sub: subject, jti: user.jti, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials.fetch(:secret_key_base))
  end
end