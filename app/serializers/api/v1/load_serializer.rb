class Api::V1::LoadSerializer < ActiveModel::Serializer
  attributes :id, :code, :delivery_date
end
