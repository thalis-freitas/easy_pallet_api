class Api::V1::ProductsController < Api::V1::ApiController
  def index
    @products = Product.page(current_page).per(per_page)
    render_paginated_collection(@products)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :ballast)
  end
end
