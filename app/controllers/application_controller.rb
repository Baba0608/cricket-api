class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  def authenticate_request
    header = request.headers["Authorization"]
    return render_unauthorized unless header

    token = header.split(" ").last
    decoded = JsonWebToken.decode(token)
    return render_unauthorized unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    render_unauthorized unless @current_user
  end

  private
    def render_unauthorized
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
end
