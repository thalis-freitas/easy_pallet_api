class Product < ApplicationRecord
  validates :name, :ballast, presence: true
end
