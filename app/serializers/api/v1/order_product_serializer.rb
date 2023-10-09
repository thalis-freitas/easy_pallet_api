class Api::V1::OrderProductSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :product_id, :quantity
end
