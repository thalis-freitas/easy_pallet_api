class Api::V1::ProductsController < Api::V1::ApiController
  def index
    @products = Product.page(current_page).per(per_page)
    render_paginated_collection(@products)
  end
end
