class FriendRequestSerializer
  def initialize(player)
    @player = player
  end

  def call
    {
      sent_requests: serialize_sent_requests,
      received_requests: serialize_received_requests
    }
  end

  private

  def serialize_sent_requests
    @player.friendships.pending.includes(:friend).map do |friendship|
      {
        friend_request_id: friendship.id,
        friend: serialize_player(friendship.friend)
      }
    end
  end

  def serialize_received_requests
    @player.received_friendships.pending.includes(:player).map do |friendship|
      {
        friend_request_id: friendship.id,
        friend: serialize_player(friendship.player)
      }
    end
  end

  def serialize_player(player)
    {
      id: player.id,
      name: player.name,
      unique_id: player.unique_id
    }
  end
end
