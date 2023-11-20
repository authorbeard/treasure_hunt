class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.json :winning_guesses, default: {}
      t.references :game, null: true, foreign_key: true
      t.timestamps
    end
  end
end
