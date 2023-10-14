class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_load, only: %i[index create]
  before_action :set_order, only: %i[show update destroy]

  def index
    @orders = @load.orders.page(current_page).per(per_page).order(id: :desc)
    render_paginated_collection(@orders)
  end

  def show
    render json: @order, status: :ok
  end

  def create
    @order = @load.orders.build(order_params)

    if @order.save
      render json: @order, status: :created
    else
      render json: { errors: formatted_errors(@order) },
             status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render json: @order, status: :ok
    else
      render json: { errors: formatted_errors(@order) },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @order.destroy
      render status: :ok
    else
      render json: { errors: @order.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def set_load
    @load = Load.find(params[:load_id])
  end

  def order_params
    params.require(:order).permit(:code, :bay)
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
