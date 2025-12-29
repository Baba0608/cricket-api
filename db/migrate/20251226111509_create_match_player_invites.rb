class CreateMatchPlayerInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :match_player_invites do |t|
      t.references :match, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
