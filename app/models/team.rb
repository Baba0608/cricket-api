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

  has_many :home_matches,
           class_name: "Match",
           foreign_key: :team_a_id

  has_many :away_matches,
           class_name: "Match",
           foreign_key: :team_b_id

  has_many :won_matches,
           class_name: "Match",
           foreign_key: :winner_team_id

  def matches
    Match.where(team_a_id: id).or(Match.where(team_b_id: id))
  end
end
