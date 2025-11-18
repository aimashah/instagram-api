class PostsController < ApplicationController
  before_action :authorize_request

  def index
    posts = Post.includes(:user, :likes, comments: :user, image_attachment: :blob)
                .order(created_at: :desc)

    render json: posts.map { |p|
      {
        id: p.id,
        caption: p.caption,
        image_url: p.image.attached? ? url_for(p.image) : nil,
        user: {
          id: p.user.id,
          name: p.user.name
        },
        likes_count: p.likes.count,
        liked: p.likes.exists?(user_id: @current_user.id), # IMPORTANT
        comments: p.comments.map { |c|
          {
            id: c.id,
            text: c.text,
            user: {
              id: c.user.id,
              name: c.user.name
            }
          }
        },
        shares: p.shares.map { |s| s.user.name }
      }
    }
  end

  def create
    post = @current_user.posts.new(caption: params[:caption])
    post.image.attach(params[:image]) if params[:image]

    if post.save
      render json: {
        id: post.id,
        caption: post.caption,
        image_url: post.image.attached? ? url_for(post.image) : nil,
        user: { id: @current_user.id, name: @current_user.name },
        likes_count: 0,
        liked: false,
        comments: []
      }, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
