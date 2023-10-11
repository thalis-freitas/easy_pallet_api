class Api::V1::ApiController < ApplicationController
  include AuthService
  include Paginable

  before_action :authorize

  rescue_from ActiveRecord::ActiveRecordError do |_exception|
    render json: { error: 'Internal Server Error' },
           status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |msg|
    render json: { message: msg }, status: :not_found
  end

  protected

  def render_paginated_collection(collection)
    render json: collection,
           meta: meta_attributes(collection),
           adapter: :json
  end

  def formatted_errors(model)
    model.errors.messages.to_h do |key, value|
      [key.to_s, "#{model.class.human_attribute_name(key)} #{value.first}"]
    end
  end
end
