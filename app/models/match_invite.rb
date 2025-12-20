class MatchInvite < ApplicationRecord
  belongs_to :inviting_team,
             class_name: "Team",
             foreign_key: :invite_by_team_id

  belongs_to :receiving_team,
             class_name: "Team",
             foreign_key: :receive_by_team_id

  enum :status, {
    pending: "PENDING",
    accepted: "ACCEPTED",
    rejected: "REJECTED"
  }
end
