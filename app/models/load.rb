class Load < ApplicationRecord
  has_many :orders, dependent: :destroy
  validates :code, :delivery_date, presence: true
end
