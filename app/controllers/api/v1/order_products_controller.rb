class Api::V1::OrderProductsController < Api::V1::ApiController
  before_action :set_order, only: %i[index create]
  before_action :set_order_product, only: %i[update destroy]

  def index
    @order_products = @order.order_products
    render json: @order_products
  end

  def create
    @order_product = @order.order_products.build(order_product_params)

    if @order_product.save
      render json: @order_product, status: :created
    else
      render json: { errors: formatted_errors(@order_product) },
             status: :unprocessable_entity
    end
  end

  def update
    if @order_product.update(order_product_params)
      render json: @order_product
    else
      render json: { errors: formatted_errors(@order_product) },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @order_product.destroy
      render status: :ok
    else
      render json: { errors: formatted_errors(@order_product) },
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

  def set_order_product
    @order_product = OrderProduct.find(params[:id])
  end
end
