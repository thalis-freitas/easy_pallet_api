class Api::V1::OrderProductsController < Api::V1::ApiController
  before_action :set_order

  def index
    @order_products = @order.order_products
    render json: @order_products
  end

  def create
    @order_product = @order.order_products.build(order_product_params)

    if @order_product.save
      render json: @order_product, status: :created
    else
      render json: { errors: @order_product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def order_product_params
    params.require(:order_product).permit(:product_id, :quantity)
  end
end
