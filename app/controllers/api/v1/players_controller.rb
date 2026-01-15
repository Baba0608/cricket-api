class Api::V1::PlayersController < ApplicationController
  before_action :set_player, only: %i[ profile update destroy friends search friend_requests]

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
    render json: @player.friends.as_json(only: [ :id, :name, :role, :unique_id ], include: [ :teams ])
  end

  # GET /players/search?q=term or /players/search?player_name=&player_unique_id=&team_name=
  def search
    players = PlayerSearch.new(search_params, current_player: @player).call

    render json: players.as_json(only: [ :id, :name, :role, :unique_id ])
  end

  # GET /players/1/friend_requests
  def friend_requests
    render json: FriendRequestSerializer.new(@player).call
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

    def search_params
      params.permit(:q, :player_name, :player_unique_id, :team_name)
    end
end
