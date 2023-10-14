require 'rails_helper'

describe Api::V1::OrdersController, type: :request do
  before do
    user = create(:user)
    token = encode_token(user_id: user.id)
    @headers = { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/loads/:load_id/orders' do
    before do
      @load = create(:load)
      create_list(:order, 3, load: @load)
    end

    context 'successful request' do
      before { get "/api/v1/loads/#{@load.id}/orders", headers: @headers }

      it { expect(response).to have_http_status(:success) }

      it 'returns the expected number of orders' do
        expect(json[:orders].count).to eql(3)
      end

      it 'returns orders with expected attributes' do
        json[:orders].each do |order|
          expect(order.keys).to include(*%i[id code bay load_id])
          expect(order.keys).not_to include(*%i[created_at updated_at])
        end
      end
    end
  end

  describe 'GET /api/v1/orders/:id' do
    context 'with a valid order ID' do
      before do
        @order = create(:order)
        get "/api/v1/orders/#{@order.id}", headers: @headers
      end

      it { expect(response).to have_http_status(:success) }

      it 'returns the order with the expected attributes' do
        expect(json[:id]).to eq(@order.id)
        expect(json[:code]).to eq(@order.code)
        expect(json[:bay]).to eq(@order.bay)
        expect(json[:load_id]).to eq(@order.load_id)
      end
    end

    context 'with an invalid order ID' do
      before { get '/api/v1/orders/9999', headers: @headers }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST /api/v1/loads/:load_id/orders' do
    context 'successful request' do
      before do
        @load = create(:load)
        @order_attributes = attributes_for(:order)

        post "/api/v1/loads/#{@load.id}/orders",
             params: { order: @order_attributes },
             headers: @headers
      end

      it { expect(response).to have_http_status(:created) }

      it 'creates a new order with the provided attributes' do
        expect(json[:code]).to eq(@order_attributes[:code])
        expect(json[:bay]).to eq(@order_attributes[:bay])
      end
    end

    context 'with invalid params' do
      before do
        @load = create(:load)

        post "/api/v1/loads/#{@load.id}/orders",
             params: { order: { bay: nil, code: '' } },
             headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if order is invalid' do
        expect(json[:errors]).to include(code: 'Código não pode ficar em branco')
        expect(json[:errors]).to include(bay: 'Baia não pode ficar em branco')
      end
    end

    context 'with invalid load_id' do
      before do
        @order_attributes = attributes_for(:order)

        post '/api/v1/loads/9999/orders',
             params: { order: @order_attributes },
             headers: @headers
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'PUT /api/v1/orders/:id' do
    context 'with valid params' do
      before do
        @order = create(:order)
        @order_attributes = attributes_for(:order)

        put "/api/v1/orders/#{@order.id}",
            params: { order: @order_attributes },
            headers: @headers
      end

      it { expect(response).to have_http_status(:ok) }

      it 'updates the order with the provided attributes' do
        @order.reload

        expect(@order.code).to eq(@order_attributes[:code])
        expect(@order.bay).to eq(@order_attributes[:bay])
      end
    end

    context 'with invalid ID' do
      before do
        @order_attributes = attributes_for(:order)

        put '/api/v1/orders/9999',
            params: { order: @order_attributes },
            headers: @headers
      end

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'with invalid params' do
      before do
        @order = create(:order)
        @invalid_attributes = { bay: nil }

        put "/api/v1/orders/#{@order.id}",
            params: { order: @invalid_attributes },
            headers: @headers
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if order is invalid' do
        expect(json).to include(:errors)
      end
    end
  end

  describe 'DELETE /api/v1/orders/:id' do
    context 'with a valid order ID' do
      before do
        @order = create(:order)
        delete "/api/v1/orders/#{@order.id}", headers: @headers
      end

      it { expect(response).to have_http_status(:ok) }

      it 'deletes the order' do
        expect(Load.exists?(@order.id)).to be_falsey
      end
    end

    context 'with an invalid order ID' do
      before { delete '/api/v1/orders/9999', headers: @headers }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
