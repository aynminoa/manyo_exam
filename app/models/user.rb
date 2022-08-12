class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :password, length: { minimum: 6 }
end
