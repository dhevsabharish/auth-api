require 'rails_helper'

RSpec.describe 'Users::SessionsController', type: :request do
  let(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    context 'with valid credentials' do
      it 'signs in the user' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('User signed-in successfully')
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        post user_session_path, params: { user: { email: user.email, password: 'invalid_password' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    context 'with a valid token' do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        @token = response.headers['Authorization']
      end
  
      it 'signs out the user' do
        delete destroy_user_session_path, headers: { 'Authorization' => @token }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Signed out successfully')
      end
    end
  
    context 'with an invalid token' do
      it 'does not sign out the user' do
        delete destroy_user_session_path, headers: { 'Authorization' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Invalid token')
      end
    end
  end
end