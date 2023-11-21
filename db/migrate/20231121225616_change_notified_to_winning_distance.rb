class ChangeNotifiedToWinningDistance < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :notified_of_win
    add_column :users, :winning_distance, :float, default: nil
  end
end
