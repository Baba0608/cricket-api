class Team < ApplicationRecord
  belongs_to :created_by_player,
             class_name: "Player",
             foreign_key: :created_by_player_id
end
