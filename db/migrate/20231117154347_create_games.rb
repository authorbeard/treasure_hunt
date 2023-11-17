class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, null: true 
      t.string :address, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.timestamps

      t.index %i[latitude longitude]
    end
  end
end
