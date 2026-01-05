class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :authenticate_request

  attr_reader :current_user

  def authenticate_request
    token = cookies[:token]
    return render_unauthorized unless token

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
