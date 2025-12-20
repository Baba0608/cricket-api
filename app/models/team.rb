class Team < ApplicationRecord
  belongs_to :created_by_player,
             class_name: "Player",
             foreign_key: :created_by_player_id

  has_many :sent_match_invites,
           class_name: "MatchInvite",
           foreign_key: :invite_by_team_id

  has_many :received_match_invites,
           class_name: "MatchInvite",
           foreign_key: :receive_by_team_id
end
