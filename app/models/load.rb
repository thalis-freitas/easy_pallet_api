class Load < ApplicationRecord
  validates :code, :delivery_date, presence: true
end
