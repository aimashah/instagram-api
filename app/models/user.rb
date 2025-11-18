class User < ApplicationRecord
  has_secure_password
  has_many :likes
  has_many :posts
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  has_many :comments
  has_many :shares
end
