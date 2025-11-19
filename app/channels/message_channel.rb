class MessageChannel < ApplicationCable::Channel
  def subscribed
    return reject unless params[:user_id].present?

    stream_from "messages_#{params[:user_id]}"
  end
end
