class Api::V1::UsersController < Api::V1::ApiController
  def index
    @users = User.page(current_page).per(per_page)
    render_paginated_collection(@users)
  end
end
