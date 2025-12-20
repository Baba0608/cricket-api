class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.integer :team_a_id, null: false
      t.integer :team_b_id, null: false
      t.integer :toss_won_by_team_id
      t.string :toss_won_by_team_choose_to
      t.integer :winner_team_id
      t.integer :won_by_runs
      t.integer :won_by_wickets
      t.integer :status, default: 0

      t.timestamps
    end

    add_foreign_key :matches, :teams, column: :team_a_id
    add_foreign_key :matches, :teams, column: :team_b_id
    add_foreign_key :matches, :teams, column: :toss_won_by_team_id
    add_foreign_key :matches, :teams, column: :winner_team_id
  end
end
