class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  def name
    username || email
  end
end
