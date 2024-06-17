require 'rails_helper'

RSpec.describe 'Users::RegistrationsController', type: :request do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password' } }
  let(:invalid_attributes) { { email: 'invalid_email' } }

  describe 'POST /users' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post user_registration_path, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'returns a successful response' do
        post user_registration_path, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          post user_registration_path, params: { user: invalid_attributes }
        }.to_not change(User, :count)
      end

      it 'returns an unprocessable entity response' do
        post user_registration_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end