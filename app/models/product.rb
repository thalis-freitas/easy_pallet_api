class Product < ApplicationRecord
  validates :name, presence: true
  has_many :order_products, dependent: :destroy
end
