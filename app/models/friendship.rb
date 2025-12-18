class Friendship < ApplicationRecord
  belongs_to :player
  belongs_to :friend, class_name: "Player"

  enum :status, {
    pending: "pending",
    accepted: "accepted",
    rejected: "rejected"
  }
end
