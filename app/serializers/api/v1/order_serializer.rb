class Api::V1::OrderSerializer < ActiveModel::Serializer
  attributes :id, :code, :bay, :load_id
end
