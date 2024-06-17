require 'rails_helper'

RSpec.describe 'Admin::LibrariansController', type: :request do
  let(:admin) { create(:user, role: :admin) }
  let(:librarian) { create(:user, role: :librarian) }
  let(:valid_attributes) { { email: 'new_librarian@example.com', password: 'password' } }
  let(:invalid_attributes) { { email: 'invalid_email' } }

  before { sign_in admin }

  describe 'POST /admin/librarians' do
    context 'with valid parameters' do
      it 'creates a new librarian' do
        expect {
          post admin_librarians_path, params: { user: valid_attributes }
        }.to change(User.librarians, :count).by(1)
      end

      it 'returns a successful response' do
        post admin_librarians_path, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new librarian' do
        expect {
          post admin_librarians_path, params: { user: invalid_attributes }
        }.to_not change(User.librarians, :count)
      end

      it 'returns an unprocessable entity response' do
        post admin_librarians_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /admin/librarians' do
    it 'returns a list of librarians' do
      get admin_librarians_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /admin/librarians/:id' do
    it 'returns a successful response' do
        delete admin_librarian_path(librarian)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Librarian deleted successfully')
      end
  end
end