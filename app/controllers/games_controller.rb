class GamesController < ApplicationController
  before_action :validate_user_presence, :validate_user_eligibility

  def create
    game = Game.generate_new
  end

  private 

  #TODO: extract error messages, possibly all error handling, to separate module, then internationalize messages
  def validate_user_presence
    if current_user.nil?
      render json: { error: 'Not found; post your email to /users to create a user' }, status: 422 and return 
    end
  end

  def validate_user_eligibility
    if current_user.game_id
      render json: { 
        error: "You already have a game in progress. Include 'game_id=#{current_user.game_id}' " \
               'with your other params in a PATCH request to resume play.' 
      }, status: 422 and return
    end
  end
end
