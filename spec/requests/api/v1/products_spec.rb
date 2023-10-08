require 'rails_helper'

describe Api::V1::ProductsController, type: :request do
  describe 'GET /api/v1/products' do
    before do
      create_list(:product, 5)
    end

    context 'successful request' do
      before { get '/api/v1/products' }

      it { expect(response).to have_http_status(:success) }

      it 'returns the expected number of products' do
        expect(json[:products].count).to eql(5)
      end

      it 'returns products with expected attributes' do
        json[:products].each do |product|
          expect(product.keys).to include(*%i[id name ballast])
          expect(product.keys).not_to include(*%i[created_at updated_at])
        end
      end
    end
  end
end
