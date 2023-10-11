class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: %i[update]

  def index
    @users = User.page(current_page).per(per_page)
    render_paginated_collection(@users)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { user: Api::V1::UserSerializer.new(@user) },
             status: :created
    else
      render json: { errors: formatted_errors(@user) },
             status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: formatted_errors(@user) },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :login, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
