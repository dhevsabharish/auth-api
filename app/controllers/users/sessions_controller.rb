class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :logout_current_user, only: [:create]

  def create
    super
  end

  private

  def logout_current_user
    sign_out(current_user) if current_user
  end

  def respond_with(resource, _opts = {})
    token = generate_jwt_token(resource)

    MongoLogger.create(event: 'user_sign_in', user_id: resource.id, email: resource.email)

    render json: {
      message: "User signed-in successfully",
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      token: token
    }, status: :ok
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user
      MongoLogger.create(event: 'user_sign_out', user_id: current_user.id, email: current_user.email)
      render json: { status: 200, message: "Signed out successfully" }, status: :ok
    else
      MongoLogger.create(event: 'user_sign_out_failed', message: "User has no active session")
      render json: { status: 401, message: "User has no active session" }, status: :unauthorized
    end
  end

  def generate_jwt_token(user)
    subject = "#{user.id}"
    payload = { sub: subject, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials.fetch(:secret_key_base))
  end
end
