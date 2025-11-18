class ApplicationController < ActionController::API
  include Rails.application.routes.url_helpers

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue StandardError
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end
end
