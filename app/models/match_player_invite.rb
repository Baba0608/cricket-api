class MatchPlayerInvite < ApplicationRecord
  belongs_to :match
  belongs_to :team
  belongs_to :player

  enum :status, {
    pending: 0,
    accepted: 1,
    rejected: 2
  }
end
