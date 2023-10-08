class Api::V1::LoadsController < Api::V1::ApiController
  include Paginable

  def index
    @loads = Load.page(current_page).per(per_page)
    render json: @loads,
           meta: meta_attributes(@loads),
           adapter: :json
  end
end
