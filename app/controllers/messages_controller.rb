class MessagesController < ApplicationController
  before_action :authorize_request

  def index
    receiver_id = params[:receiver_id]

    if receiver_id.blank?
      render json: { error: "receiver_id param is required" }, status: :unprocessable_entity
      return
    end

    @messages = Message.where(sender_id: @current_user.id, receiver_id: receiver_id)
                       .or(Message.where(sender_id: receiver_id, receiver_id: @current_user.id))
                       .includes(:sender, :receiver)
                       .order(:created_at)

    render json: @messages.map { |message| serialize_message(message) }
  end

  def create
    @message = Message.new(message_params)
    @message.sender = @current_user

    if @message.save
      payload = serialize_message(@message)
      ActionCable.server.broadcast "messages_#{@message.receiver_id}", payload
      ActionCable.server.broadcast "messages_#{@current_user.id}", payload
      render json: payload, status: :created
    else
      render json: {
        error: "Message could not be sent",
        details: @message.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :content)
  end

  def serialize_message(message)
    message.as_json(
      only: [ :id, :content, :sender_id, :receiver_id, :created_at, :updated_at, :read ],
      include: {
        sender: { only: [ :id, :name ] },
        receiver: { only: [ :id, :name ] }
      }
    )
  end
end
