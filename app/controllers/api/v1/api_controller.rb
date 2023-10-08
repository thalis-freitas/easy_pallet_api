class Api::V1::ApiController < ActionController::API
  include Paginable

  rescue_from ActiveRecord::ActiveRecordError do |_exception|
    render json: { error: 'Internal Server Error' },
           status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |msg|
    render json: { message: msg }, status: :not_found
  end

  def render_paginated_collection(collection)
    render json: collection,
           meta: meta_attributes(collection),
           adapter: :json
  end
end
