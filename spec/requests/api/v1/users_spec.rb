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
end
