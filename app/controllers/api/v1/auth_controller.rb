class Api::V1::AuthController < Api::V1::ApiController
  skip_before_action :authorize, only: :login

  def login
    @user = User.find_by(login: login_params[:login])

    if @user&.authenticate(login_params[:password])
      render json: {
        user: Api::V1::UserSerializer.new(@user),
        token: encode_token({ user_id: @user.id })
      }, status: :ok
    else
      render json: { errors: I18n.t('errors.login_or_password_invalid') },
             status: :unprocessable_entity
    end
  end

  private

  def login_params
    params.require(:user).permit(:login, :password)
  end
end
