class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.string :name
      t.string :status
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
