class Api::V1::LoadsController < Api::V1::ApiController
  include Paginable

  def index
    @loads = Load.page(current_page).per(per_page)
    render json: @loads,
           meta: meta_attributes(@loads),
           adapter: :json
  end

  def create
    @load = Load.new(load_params)

    if @load.save
      render json: @load, status: :created
    else
      render json: { errors: @load.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def load_params
    params.require(:load).permit(:code, :delivery_date)
  end
end
