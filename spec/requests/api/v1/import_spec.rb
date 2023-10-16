require 'rails_helper'

describe Api::V1::ImportController, type: :request do
  before do
    user = create(:user)
    token = encode_token(user_id: user.id)
    @headers = { 'Authorization' => "Bearer #{token}" }
  end

  describe 'POST /api/v1/import/users/' do
    context 'when the file is a valid XLSX' do
      before do
        xlsx_file = fixture_file_upload('users/valid.xlsx',
                                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        post '/api/v1/import/users',
             params: { file: xlsx_file },
             headers: @headers
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates 4 users' do
        expect(User.count).to eq(5)
      end
    end

    context 'when the file is invalid' do
      before do
        invalid_file = fixture_file_upload('invalid.txt', 'text/plain')

        post '/api/v1/import/users',
             params: { file: invalid_file },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an error message' do
        expect(json).to include(error: 'Formato de arquivo inválido')
      end
    end

    context 'when an unexpected error occurs during import' do
      before do
        allow(UserImportService).to receive(:new).and_raise(StandardError)
        xlsx_file = fixture_file_upload('products/valid.xlsx',
                                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

        post '/api/v1/import/users',
             params: { file: xlsx_file },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an error message' do
        expect(json)
          .to include(error: 'Ocorreu um erro inesperado ao processar o arquivo')
      end
    end
  end

  describe 'POST /api/v1/import/products/' do
    context 'when the file is a valid XLSX' do
      before do
        xlsx_file = fixture_file_upload('products/valid.xlsx',
                                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
        post '/api/v1/import/products',
             params: { file: xlsx_file },
             headers: @headers
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates 4 products' do
        expect(Product.count).to eq(3)
      end
    end

    context 'when the file is invalid' do
      before do
        invalid_file = fixture_file_upload('invalid.txt', 'text/plain')

        post '/api/v1/import/products',
             params: { file: invalid_file },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an error message' do
        expect(json).to include(error: 'Formato de arquivo inválido')
      end
    end

    context 'when an unexpected error occurs during import' do
      before do
        allow(ProductImportService).to receive(:new).and_raise(StandardError)
        xlsx_file = fixture_file_upload('products/valid.xlsx',
                                        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

        post '/api/v1/import/products',
             params: { file: xlsx_file },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns an error message' do
        expect(json)
          .to include(error: 'Ocorreu um erro inesperado ao processar o arquivo')
      end
    end
  end
end
