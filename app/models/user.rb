class User < ApplicationRecord
  belongs_to :game, optional: true
  has_many :user_guesses

  validates :email, presence: true, uniqueness: true
  scope :winners, ->{ where.not(winning_guess: nil) }

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
    user_guesses.active.order(created_at: :asc).last.created_at + 1.hour
  end

  def log_guess 
    user_guesses.create
  end

  def record_win(coord_string)
    update(winning_guess: coord_string.split(',').map(&:to_f))
  end
end
