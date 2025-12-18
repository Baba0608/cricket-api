class CreateFriendships < ActiveRecord::Migration[8.0]
  def change
    create_table :friendships do |t|
      t.references :player, null: false, foreign_key: { to_table: :players }
      t.references :friend, null: false, foreign_key: { to_table: :players }
      t.string :status

      t.timestamps
    end

    add_index :friendships, [ :player_id, :friend_id ], unique: true
  end
end
