class LikesController < ApplicationController
  before_action :authorize_request
  def toggle
  post = Post.find(params[:post_id])
  like = Like.find_by(user_id: @current_user.id, post_id: post.id)

  if like
    like.destroy
    liked = false
  else
    Like.create(user_id: @current_user.id, post_id: post.id)
    liked = true
  end

  render json: {
    liked: liked,
    likes_count: post.likes.count
  }
  end
end
