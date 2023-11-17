class User < ApplicationRecord
  belongs_to :game, optional: true
  
  validates :email, presence: true, uniqueness: true

  def name
    username || email
  end
end
