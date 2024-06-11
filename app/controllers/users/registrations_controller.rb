# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :logout_current_user, only: [:create]
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_with(resource)
      else
        expire_data_after_sign_in!
        respond_with(resource, location: after_inactive_sign_up_path_for(resource))
      end
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      respond_with(resource)
    end
  end

  private

  def logout_current_user
    sign_out(current_user) if current_user
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      MongoLogger.create(event: 'user_sign_up', user_id: resource.id, email: resource.email)
      token = generate_jwt_token(resource)
      render json: {
        status: {
          code: 200,
          message: 'Signed Up Successfully',
        },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes],
        token: token
      }, status: :ok
    else
      MongoLogger.create(event: 'user_sign_up_failed', errors: resource.errors.full_messages)
      render json: {
        status: {
          message: 'User could not be created successfully',
          errors: resource.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def generate_jwt_token(user)
    subject = "#{user.id}"
    payload = { sub: subject, jti: user.jti, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials.fetch(:secret_key_base))
  end

  protected

  def configure_sign_up_params
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end
end
