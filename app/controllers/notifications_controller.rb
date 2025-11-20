class NotificationsController < ApplicationController
  before_action :authorize_request

  def index
    notifications = @current_user.notifications
                                  .includes(message: :sender)
                                  .order(created_at: :desc)

    render json: notifications.map { |notification| serialize_notification(notification) }
  end

  def update
    notification = @current_user.notifications.find_by(id: params[:id])
    if notification.nil?
      render json: { error: "Notification not found" }, status: :not_found
      return
    end

    notification.mark_read! unless notification.read?
    render json: serialize_notification(notification)
  end

  def mark_thread
    receiver_id = params[:receiver_id]
    if receiver_id.blank?
      render json: { error: "receiver_id param is required" }, status: :unprocessable_entity
      return
    end

    notifications_scope = @current_user.notifications
                                        .joins(:message)
                                        .where(messages: { sender_id: receiver_id })

    notification_ids = notifications_scope.pluck(:id)
    notifications_scope.unread.update_all(read_at: Time.current) if notification_ids.any?

    Message.where(sender_id: receiver_id, receiver_id: @current_user.id)
           .where(read: [ nil, false ])
           .update_all(read: true, updated_at: Time.current)

    render json: {
      receiver_id: receiver_id.to_i,
      cleared_notification_ids: notification_ids
    }
  end

  private

  def serialize_notification(notification)
    notification.as_json(
      only: [ :id, :preview, :read_at, :created_at, :updated_at ],
      methods: [ :read? ],
      include: {
        message: {
          only: [ :id, :content, :sender_id, :receiver_id, :created_at, :updated_at ],
          include: {
            sender: { only: [ :id, :name, :email ] }
          }
        }
      }
    ).merge(user_id: notification.user_id)
  end
end
