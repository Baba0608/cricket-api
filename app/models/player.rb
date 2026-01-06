class Player < ApplicationRecord
  belongs_to :user
  has_many :teams,
           foreign_key: :created_by_player_id,
           dependent: :destroy

  has_many :friendships, dependent: :destroy

  has_many :friends,
           -> { where(friendships: { status: "accepted" }) },
           through: :friendships,
           source: :friend

  has_many :match_player_invites

  has_many :received_friendships,
           class_name: "Friendship",
           foreign_key: :friend_id,
           dependent: :destroy
end
