class Match < ApplicationRecord
  belongs_to :team_a, class_name: "Team"
  belongs_to :team_b, class_name: "Team"

  has_one :toss_won_by_team, class_name: "Team"
  has_one :winner_team, class_name: "Team"

  has_many :match_player_invites

  enum :status, {
    not_started: 0,
    first_innings_inprogress: 1,
    first_innings_completed: 2,
    second_innings_inprogress: 3,
    super_over_inprogress: 4,
    completed: 5
  }


  def teams
    [ team_a, team_b ].compact
  end
end
