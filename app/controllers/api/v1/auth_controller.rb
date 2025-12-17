class Api::V1::AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :signup ]


  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token:, user: }
    else
      render json: { error: "Invalid email or passowrd" }, status: :unauthorised
    end
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
