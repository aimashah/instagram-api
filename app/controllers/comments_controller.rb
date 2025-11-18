class CommentsController < ApplicationController
  before_action :authorize_request

  def create
    post = Post.find(params[:post_id])

    comment = post.comments.create!(
      user: @current_user,
      text: params[:text]
    )

    render json: {
      id: comment.id,
      text: comment.text,
      user: {
        id: @current_user.id,
        name: @current_user.name
      }
    }, status: :created
  end
end
