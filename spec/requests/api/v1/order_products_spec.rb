require 'rails_helper'

describe Api::V1::OrderProductsController, type: :request do
  describe 'GET /api/v1/orders/:order_id/order_products' do
    before do
      @order = create(:order)
      create_list(:order_product, 4, order: @order)
    end

    context 'successful request' do
      before { get "/api/v1/orders/#{@order.id}/order_products" }

      it { expect(response).to have_http_status(:success) }

      it 'returns the expected number of order products' do
        expect(json.count).to eql(4)
      end

      it 'returns order productss with expected attributes' do
        json.each do |order_product|
          expect(order_product.keys)
            .to include(*%i[id order_id product_id quantity])

          expect(order_product.keys).not_to include(*%i[created_at updated_at])
        end
      end
    end
  end

  describe 'POST /api/v1/orders/:order_id/order_products' do
    before do
      @order = create(:order)
      @product = create(:product)
    end

    context 'successful request' do
      before do
        @attributes = attributes_for(:order_product, product_id: @product.id)

        post "/api/v1/orders/#{@order.id}/order_products",
             params: { order_product: @attributes }
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates a new order_product associated with the order' do
        expect(json[:order_id]).to eq(@order.id)
        expect(json[:product_id]).to eq(@attributes[:product_id])
        expect(json[:quantity]).to eq(@attributes[:quantity])
      end
    end

    context 'with invalid params' do
      before do
        create(:order_product, order: @order, product: @product)

        @invalid_attributes = attributes_for(
          :order_product,
          product_id: @product.id
        )

        post "/api/v1/orders/#{@order.id}/order_products",
             params: { order_product: @invalid_attributes }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if order_product is invalid' do
        expect(json[:errors]).to include(product_id: 'Produto já está em uso')
      end
    end
  end

  describe 'PUT /api/v1/order_products/:id' do
    before { @order_product = create(:order_product) }

    context 'successful request' do
      before do
        @attributes = { quantity: '10' }

        put "/api/v1/order_products/#{@order_product.id}",
            params: { order_product: @attributes }
      end

      it { expect(response).to have_http_status(:success) }

      it 'updates the order product with the provided attributes' do
        @order_product.reload
        expect(@order_product.quantity).to eq(@attributes[:quantity])
      end
    end

    context 'with invalid params' do
      before do
        put "/api/v1/order_products/#{@order_product.id}",
            params: { order_product: { quantity: '' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if order_product is invalid' do
        expect(json[:errors])
          .to include(quantity: 'Quantidade não pode ficar em branco')
      end
    end
  end

  describe 'DELETE /api/v1/order_products/:id' do
    before { @order_product = create(:order_product) }

    context 'with a valid order ID' do
      before { delete "/api/v1/order_products/#{@order_product.id}" }

      it { expect(response).to have_http_status(:ok) }

      it 'deletes the order product' do
        expect(Load.exists?(@order_product.id)).to be_falsey
      end
    end

    context 'with an invalid order product ID' do
      before { delete '/api/v1/orders/9999' }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
