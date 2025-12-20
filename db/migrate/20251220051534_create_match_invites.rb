class CreateMatchInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :match_invites do |t|
      t.integer :invite_by_team_id
      t.integer :receive_by_team_id
      t.string :status

      t.timestamps
    end

    add_foreign_key :match_invites, :teams, column: :invite_by_team_id
    add_foreign_key :match_invites, :teams, column: :receive_by_team_id
  end
end
