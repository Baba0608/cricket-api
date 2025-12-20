class UpdatePlayerIdToCreatedByInTeamsTable < ActiveRecord::Migration[8.0]
  def change
    rename_column :teams, :player_id, :created_by_player_id
    add_foreign_key :teams, :players, column: :created_by_player_id
  end
end
