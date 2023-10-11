class User < ApplicationRecord
  has_secure_password

  validates :name, :login, presence: true
  validates :login, uniqueness: true
  validates :password, length: { minimum: 4 }
end
