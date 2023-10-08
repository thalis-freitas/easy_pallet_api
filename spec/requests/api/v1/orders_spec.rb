require 'rails_helper'

describe Api::V1::OrdersController, type: :request do
  describe 'GET /api/v1/loads/:load_id/orders' do
    before do
      @load = create(:load)
      create_list(:order, 3, load: @load)
    end

    context 'successful request' do
      before { get "/api/v1/loads/#{@load.id}/orders" }

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

  describe 'POST /api/v1/loads/:load_id/orders' do
    context 'successful request' do
      before do
        @load = create(:load)
        @order_attributes = attributes_for(:order)

        post "/api/v1/loads/#{@load.id}/orders",
             params: { order: @order_attributes }
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
             params: { order: { bay: nil, code: '' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'returns validation errors if order is invalid' do
        expect(json[:errors]).to include('Código não pode ficar em branco')
        expect(json[:errors]).to include('Baia não pode ficar em branco')
      end
    end

    context 'with invalid load_id' do
      before do
        @order_attributes = attributes_for(:order)

        post '/api/v1/loads/9999/orders', params: { order: @order_attributes }
      end

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
