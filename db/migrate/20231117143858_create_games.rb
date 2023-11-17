class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps
    end
  end
end
