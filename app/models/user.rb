class User < ApplicationRecord
  has_secure_password
  has_many :likes
  has_many :posts
  has_many :notifications, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  has_many :comments
  has_many :shares
end
