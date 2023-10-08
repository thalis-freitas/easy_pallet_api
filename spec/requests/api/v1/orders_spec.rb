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
end
