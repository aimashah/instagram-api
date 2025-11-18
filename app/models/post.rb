class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_one_attached :image
  validates :caption, presence: true
  def image_url
    image.attached? ? Rails.application.routes.url_helpers.url_for(image) : nil
  end
end