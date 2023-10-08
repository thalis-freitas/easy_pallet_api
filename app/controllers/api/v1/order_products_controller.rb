class Api::V1::OrderProductsController < Api::V1::ApiController
  before_action :set_order

  def index
    @order_products = @order.order_products
    render json: @order_products
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end
