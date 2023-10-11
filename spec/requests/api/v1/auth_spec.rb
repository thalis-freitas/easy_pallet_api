require 'rails_helper'

describe Api::V1::AuthController, type: :request do
  describe 'POST /api/v1/login' do
    context 'with valid username and password' do
      before do
        @user = create(:user)
        post '/api/v1/login',
             params: { user: { login: @user.login, password: @user.password } }
      end

      it { expect(response).to have_http_status(:ok) }

      it 'returns an authentication token' do
        expect(json).to have_key(:token)
      end

      it 'returns user with expected attributes' do
        expect(json[:user].keys).to include(*%i[id name login])

        expect(json[:user].keys)
          .not_to include(*%i[password created_at updated_at])
      end
    end

    context 'with invalid username or password' do
      before do
        post '/api/v1/login',
             params: { user: { login: 'user', password: 'wrong_password' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an authentication error' do
        expect(json[:errors]).to include('Usuário ou senha inválidos')
      end
    end
  end
end
