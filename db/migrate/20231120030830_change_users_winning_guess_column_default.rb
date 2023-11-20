class ChangeUsersWinningGuessColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :winning_guess, nil
  end
end
