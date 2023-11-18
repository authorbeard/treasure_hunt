class UserGuess < ApplicationRecord 
  belongs_to :user 

  scope :active, -> { where("created_at < ?", 1.hour.ago) }
end