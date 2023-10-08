class Api::V1::ApiController < ActionController::API
  rescue_from StandardError do |_exception|
    render json: { error: 'Internal Server Error' },
           status: :internal_server_error
  end
end
