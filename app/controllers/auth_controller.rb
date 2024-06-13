class AuthController < ApplicationController
    def verify_token
      token = request.headers['Authorization'].split(' ').last
      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base))
        user_id = decoded_token[0]['sub']
        user = User.find(user_id)
        # print user
        puts "decoded_token"
        puts decoded_token
        puts "user"
        puts user.jti
        puts "user email"
        puts user.email
        if user && user.jti == decoded_token[0]['jti']
          render json: { role: user.role, user_id: user.id }, status: :ok
        else
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    end
  end