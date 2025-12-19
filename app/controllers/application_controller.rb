class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user, :current_player

  def authenticate_request
    header = request.headers["Authorization"]
    return render_unauthorized unless header

    token = header.split(" ").last
    decoded = JsonWebToken.decode(token)
    return render_unauthorized unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    render_unauthorized unless @current_user

    @current_player = @current_user.player
    render_player_missing unless @current_player
  end

  private
    def render_unauthorized
      render json: { error: "Unauthorized" }, status: :unauthorized
    end

    def render_player_missing
      render json: { error: "Player profile missing for the user" }, status: :unprocessable_content
    end
end
