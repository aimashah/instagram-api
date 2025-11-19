class ApplicationController < ActionController::API
  include Rails.application.routes.url_helpers

  private

  def authorize_request
    header = request.headers["Authorization"]
    if header.nil? || !header.start_with?("Bearer ")
      render json: { message: "Unauthorized: Missing or Invalid token" }, status: :unauthorized
      return
    end
    token = header.split(" ").last

    begin
      decoded = JsonWebToken.decode(token)
      @current_user = User.find_by(id: decoded[:user_id])

      if @current_user.nil?
        render json: { message: "Unauthorized: User not found" }, status: :unauthorized
      end
    rescue JWT::ExpiredSignature
      render json: { message: "Unauthorized: Token has expired" }, status: :unauthorized
    rescue StandardError => e
      render json: { message: "Unauthorized: #{e.message}" }, status: :unauthorized
    end
  end
end
