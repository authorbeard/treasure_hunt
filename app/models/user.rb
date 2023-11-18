class User < ApplicationRecord
  belongs_to :game, optional: true
  has_many :user_guesses

  validates :email, presence: true, uniqueness: true

  def name
    username || email
  end

  def winner? 
    winning_guess.present?
  end

  def rate_limited?
    user_guesses.active.count >= 5
  end

  def next_available_guess_time
    first_in_window = user_guesses.active.order(created_at: :asc).last.created_at
    (first_in_window + 1.hour).to_fs(:long)
  end

  def record_win(coord_string)
    update(winning_guess: coord_string.split(',').map(&:to_f))
  end
end
