class RenameWinningGuessestoWinningGuessAndChangeDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :winning_guesses, []
    rename_column :users, :winning_guesses, :winning_guess
  end
end
