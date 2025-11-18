class SharesController < ApplicationController
  before_action :authorize_request

  def create
    post = Post.find(params[:post_id])

    Share.create(user: @current_user, post: post)

    render json: { message: "Post shared successfully" }, status: :created
  end
end
