class Player < ApplicationRecord
  belongs_to :user
  has_many :teams
  has_many :matches

  has_many :friendships, dependent: :destroy

  has_many :friends,
           -> { where(friendships: { status: "accepted" }) },
           through: :friendships,
           source: :friend

  has_many :received_friendships,
           class_name: "Friendship",
           foreign_key: :friend_id,
           dependent: :destroy
end
