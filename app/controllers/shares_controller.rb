class SharesController < ApplicationController
  before_action :authorize_request

  def create
    post = Post.find(params[:post_id])

    Share.create(user_id: @current_user.id, post_id: post.id)

    render json: { message: "Post shared successfully" }
  end
end
