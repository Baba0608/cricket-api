class Api::V1::PlayersController < ApplicationController
  before_action :set_player, only: %i[ profile update destroy friends ]

  # GET /players/profile
  def profile
    render json: @player
  end

  # GET /players/1
  def show
    @player = Player.find(id: params[:id])
    render json: @player
  end

  # POST /players
  def create
    @player = current_user.build_player(player_params)

    if @player.save
      render json: @player, status: :created
    else
      render json: @player.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /players/1
  def update
    if @player.update(player_params)
      render json: @player
    else
      render json: @player.errors, status: :unprocessable_content
    end
  end

  # DELETE /players/1
  def destroy
    @player.destroy!
  end

  # GET /players/1/friends
  def friends
    render json: @player.friends.as_json(only: [ :id, :name, :role, :unique_id ])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find_by!(user_id: current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.expect(player: [ :name, :role, :bat_hand, :bowl_hand, :unique_id, :user_id ])
    end
end
