class Message < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
  has_one :notification, dependent: :destroy

  validates :content, presence: true

  after_commit :create_notification_for_receiver, on: :create

  private

  def create_notification_for_receiver
    return if receiver.nil?

    Notification.create!(
      user: receiver,
      message: self,
      preview: Notification.preview_for(content)
    )
  rescue StandardError => e
    Rails.logger.error("Failed to create notification for message #{id}: #{e.message}")
  end
end
