class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_load, only: %i[index create]

  def index
    @orders = @load.orders.page(current_page).per(per_page)
    render_paginated_collection(@orders)
  end

  def create
    @order = @load.orders.build(order_params)

    if @order.save
      render json: @order, status: :created
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
end
