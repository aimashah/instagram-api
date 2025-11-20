class UsersController < ApplicationController
  before_action :authorize_request

  def index
    users = User.where.not(id: @current_user.id).order(:name)

    render json: users.select(:id, :name, :email)
  end
end
