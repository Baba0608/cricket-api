class Player < ApplicationRecord
  belongs_to :user
  has_many :teams
  has_many :matches
end
