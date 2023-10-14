require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  before do
    user = create(:user)
    token = encode_token(user_id: user.id)
    @headers = { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/users' do
    before do
      create_list(:user, 3)
    end

    context 'successful request' do
      before { get '/api/v1/users', headers: @headers }

      it { expect(response).to have_http_status(:success) }

      it 'returns the expected number of users' do
        expect(json[:users].count).to eql(4)
      end

      it 'returns users with expected attributes' do
        json[:users].each do |user|
          expect(user.keys).to include(*%i[id name login])
          expect(user.keys).not_to include(*%i[password created_at updated_at])
        end
      end
    end
  end

  describe 'GET /api/v1/users/:id' do
    context 'with a valid user ID' do
      before do
        @user = create(:user)
        get "/api/v1/users/#{@user.id}", headers: @headers
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns the user with the expected attributes' do
        expect(json[:id]).to eq(@user.id)
        expect(json[:name]).to eq(@user.name)
        expect(json[:login]).to eq(@user.login)
      end
    end

    context 'with an invalid user ID' do
      before { get '/api/v1/users/9999', headers: @headers }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST /api/v1/users' do
    context 'successful request' do
      before do
        @user_attributes = attributes_for(:user)
        post '/api/v1/users',
             params: { user: @user_attributes },
             headers: @headers
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates a new user with the provided attributes' do
        expect(json[:user]).to include(name: @user_attributes[:name])
        expect(json[:user]).to include(login: @user_attributes[:login])
      end
    end

    context 'with invalid params' do
      before do
        post '/api/v1/users',
             params: { user: { password: '123' } },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if user is invalid' do
        expect(json[:errors]).to include(name: 'Nome não pode ficar em branco')

        expect(json[:errors])
          .to include(login: 'Login não pode ficar em branco')

        expect(json[:errors])
          .to include(password: 'Senha deve conter, no mínimo, 4 caracteres')
      end
    end

    context 'when trying to register with an existing login' do
      before do
        create(:user, login: 'user')

        post '/api/v1/users',
             params: { user: { name: 'User', login: 'user', password: 'pass' } },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an error message for login' do
        expect(json[:errors]).to include(login: 'Login já está em uso')
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    context 'with valid params' do
      before do
        @user = create(:user)
        @user_attributes = attributes_for(:user)

        put "/api/v1/users/#{@user.id}",
            params: { user: @user_attributes },
            headers: @headers
      end

      it { expect(response).to have_http_status(:ok) }

      it 'updates the user with the provided attributes' do
        @user.reload

        expect(@user.name).to eq(@user_attributes[:name])
        expect(@user.login).to eq(@user_attributes[:login])
      end
    end

    context 'with invalid params' do
      before do
        @user = create(:user)
        @invalid_attributes = { password: nil }

        put "/api/v1/users/#{@user.id}",
            params: { user: @invalid_attributes },
            headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if user is invalid' do
        expect(json).to include(:errors)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    context 'with a valid user ID' do
      before do
        @user = create(:user)
        delete "/api/v1/users/#{@user.id}", headers: @headers
      end

      it { expect(response).to have_http_status(:ok) }

      it 'deletes the user' do
        expect(Load.exists?(@user.id)).to be_falsey
      end
    end

    context 'with an invalid user ID' do
      before { delete '/api/v1/users/999', headers: @headers }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
