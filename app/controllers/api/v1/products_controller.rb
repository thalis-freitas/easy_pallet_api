class Api::V1::ProductsController < Api::V1::ApiController
  before_action :set_product, only: %i[update destroy]

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

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: { errors: @product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      render status: :ok
    else
      render json: { errors: @product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :ballast)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
