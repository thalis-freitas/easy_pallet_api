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

  describe 'POST /api/v1/products' do
    context 'successful request' do
      before do
        @product_attributes = attributes_for(:product)
        post '/api/v1/products', params: { product: @product_attributes }
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates a new product with the provided attributes' do
        expect(json[:name]).to eq(@product_attributes[:name])
        expect(json[:ballast]).to eq(@product_attributes[:ballast])
      end
    end

    context 'with invalid params' do
      before do
        post '/api/v1/products',
             params: { product: { name: '' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if product is invalid' do
        expect(json[:errors]).to include('Nome não pode ficar em branco')
        expect(json[:errors]).to include('Lastro não pode ficar em branco')
      end
    end
  end

  describe 'PUT /api/v1/products/:id' do
    context 'with valid params' do
      before do
        @product = create(:product)
        @product_attributes = attributes_for(:product)

        put "/api/v1/products/#{@product.id}",
            params: { product: @product_attributes }
      end

      it { expect(response).to have_http_status(:ok) }

      it 'updates the product with the provided attributes' do
        @product.reload

        expect(@product.name).to eq(@product_attributes[:name])
        expect(@product.ballast).to eq(@product_attributes[:ballast])
      end
    end

    context 'with invalid params' do
      before do
        @product = create(:product)
        @invalid_attributes = { ballast: nil }

        put "/api/v1/products/#{@product.id}",
            params: { product: @invalid_attributes }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if product is invalid' do
        expect(json).to include(:errors)
      end
    end
  end
end
