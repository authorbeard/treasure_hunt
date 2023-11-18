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

  def record_win(coord_string)
    update(winning_guess: coord_string.split(',').map(&:to_f))
  end
end
