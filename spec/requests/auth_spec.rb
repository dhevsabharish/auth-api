require 'rails_helper'

RSpec.describe 'AuthController', type: :request do
  let(:user) { create(:user) }
  let(:valid_token) { generate_jwt_token(user) }

  describe 'POST /verify_token' do
    context 'with a valid token' do
      it 'returns the user role and id' do
        post verify_token_path, headers: { 'Authorization' => "Bearer #{valid_token}" }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.role.to_s)
        expect(response.body).to include(user.id.to_s)
      end
    end

    context 'with an invalid token' do
      it 'returns an unauthorized response' do
        post verify_token_path, headers: { 'Authorization' => 'invalid_token' }
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('Invalid token')
      end
    end
  end
end