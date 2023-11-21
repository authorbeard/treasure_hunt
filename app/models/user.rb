class User < ApplicationRecord
  belongs_to :game, optional: true
  has_many :user_guesses

  validates :email, presence: true, uniqueness: true
  scope :winners, ->{ where.not(winning_guess: nil) }

  #NOTE: This name is not very good but I can't think of a better one right now. 
  def self.formatted_winners 
    winners.map do |winner|
      {
        name: winner.name,
        winning_distance: winner.winning_distance
      }
    end
  end

  def name
    username || email_handle
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

  def record_win(coord_string, distance)
    update(winning_guess: coord_string.split(',').map(&:to_f), winning_distance: distance)
  end

  # Since we only check user emails for auth, an users can only win once, avoid revealing
  # other users' email addresses if they haven't supplied a username.
  def email_handle 
    @email_handle ||= email.split('@').shift
  end
end
