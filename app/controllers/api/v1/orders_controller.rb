class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_load, only: %i[index]

  def index
    @orders = @load.orders.page(current_page).per(per_page)
    render json: @orders,
           meta: meta_attributes(@orders),
           adapter: :json
  end

  private

  def set_load
    @load = Load.find(params[:load_id])
  end
end
