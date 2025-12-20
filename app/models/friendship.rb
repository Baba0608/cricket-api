class Friendship < ApplicationRecord
  belongs_to :player
  belongs_to :friend, class_name: "Player"

  enum :status, {
    pending: "PENDING",
    accepted: "ACCEPTED",
    rejected: "REJECTED"
  }
end
