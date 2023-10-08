class OrderSerializer < ActiveModel::Serializer
  attributes :id, :code, :bay, :load_id
end
