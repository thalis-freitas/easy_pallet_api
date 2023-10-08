class Order < ApplicationRecord
  validates :code, :bay, presence: true
  belongs_to :load
end
