# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

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

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        status: {
          code: 200,
          message: 'Signed Up Successfully',
          data: resource
        }
      }, status: :ok
    else
      render json: {
        status: {
          message: 'User could not be created successfully',
          errors: resource.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end
end
