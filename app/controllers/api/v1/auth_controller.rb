class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :signup ]

  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      set_auth_cookie(token)
      render json: { user: user.as_json(only: [ :id, :name, :email ]) }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      set_auth_cookie(token)
      render json: { user: user.as_json(only: [ :id, :name, :email ]) }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def logout
    cookies.delete(:token, path: "/")
    render json: { message: "Logged out successfully" }
  end

  def me
    render json: { user: current_user.as_json(only: [ :id, :name, :email ]) }
  end

  private

  def set_auth_cookie(token)
    cookies[:token] = {
      value: token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: 7.days.from_now,
      path: "/"
    }
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
