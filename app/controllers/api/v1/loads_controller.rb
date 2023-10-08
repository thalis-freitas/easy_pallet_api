class Api::V1::LoadsController < Api::V1::ApiController
  before_action :set_load, only: %i[update destroy]

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

  def update
    if @load.update(load_params)
      render json: @load, status: :ok
    else
      render json: { errors: @load.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @load.destroy
      render status: :ok
    else
      render json: { errors: @load.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def load_params
    params.require(:load).permit(:code, :delivery_date)
  end

  def set_load
    @load = Load.find(params[:id])
  end
end
