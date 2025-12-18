class Api::V1::FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[ accept reject ]

  # post /friendships -> send request
  def create
    friend_uid = params.dig(:friendship, :unique_id)
    return render json: { errors: [ "unique_id required" ] }, status: :bad_request unless friend_uid

    friend = Player.find_by!(unique_id: friend_uid)

    # prevent self-friend
    if friend == current_user.player
      return render json: { errors: [ "Cannot friend yourself" ] }, status: :unprocessable_entity
    end

    # prevent duplicate or reverse friendship
    existing = Friendship.find_by(
      player: current_user.player,
      friend: friend
    ) || Friendship.find_by(
      player: friend,
      friend: current_user.player
    )

    if existing
      return render json: { errors: [ "Friend request or friendship already exists" ] }, status: :unprocessable_entity
    end

    @friendship = current_user.player.friendships.build(friend:, status: :pending)

    if @friendship.save
      render json: @friendship, status: :created
    else
      render json:  @friendship.errors, status: :unprocessable_content
    end
  end

  # post /friendships/:id/accept
  def accept
    friendship = Friendship.find(params[:id])

    ActiveRecord::Base.transaction do
      friendship.update!(status: :accepted)

      Friendship.create!(
        player_id: current_user.player.id,
        friend_id: friendship.player_id,
        status: :accepted
      )
    end

    render json: { message: "Friend request accepted" }
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { errors: [ e.message ] }, status: :unprocessable_entity
  end

  # post /friendships/:id/reject
  def reject
    friendship = Friendship.find(params[:id])

    friendship.update!(status: :rejected)
    render json: { message: "Friend request Rejected" }

  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    render json: { errors: [ e.message ] }, status: :unprocessable_entity
  end

  private
    def set_friendship
      @friendship = Friendship.find_by(id: params[:id])
    end

    def friendship_params
      params.expect(friendship: [ :player_id, :friend_id, :status ])
    end
end
