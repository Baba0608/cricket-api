class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :role
      t.string :bat_hand
      t.string :bowl_hand
      t.string :unique_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
