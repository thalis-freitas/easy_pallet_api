class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_load, only: %i[index]

  def index
    @orders = @load.orders.page(current_page).per(per_page)
    render_paginated_collection(@orders)
  end

  private

  def set_load
    @load = Load.find(params[:load_id])
  end
end
