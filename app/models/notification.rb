class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :message

  validates :preview, presence: true

  scope :unread, -> { where(read_at: nil) }

  def read?
    read_at.present?
  end

  def mark_read!
    update!(read_at: Time.current)
  end

  def self.preview_for(text)
    normalized = text.to_s.strip
    return "Sent you a message." if normalized.blank?
    normalized.length > 80 ? "#{normalized[0...80]}..." : normalized
  end
end
