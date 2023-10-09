class Order < ApplicationRecord
  belongs_to :load
  has_many :order_products, dependent: :destroy

  validates :code, :bay, presence: true
end
