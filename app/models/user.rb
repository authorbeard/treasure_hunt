class User < ApplicationRecord
  validates :username, :email, presence: true
  before_validation :set_username, on: :create

  private 

  def set_username 
    self.username = email if username.blank?
  end
end
