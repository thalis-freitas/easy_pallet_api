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
end
