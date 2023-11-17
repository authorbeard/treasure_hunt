class GamesController < ApplicationController
  before_action :validate_user

  def create
  end

  private 

  def validate_user
    if current_user.nil?
      render json: { error: 'Not found; post your email to /users to create a user' }, status: 422 and return 
    end
  end
end
