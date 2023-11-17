class GamesController < ApplicationController
  before_action :validate_user_presence, :validate_user_eligibility

  def create
    game = Game.generate_new
    current_user.update(game_id: game.id)

    #TODO: Extract this message to its own method or to another class.
    render json: {
      message: "Welcome to game #{game.id}, #{current_user.name}. To play, send a PATCH request to /games/#{game.id}. "\
      "Be sure to include your email address, the game id and your coordinates as params, using the keys 'email' and 'coordinates'. "\
      "Coordinates should be formatted as a string: 'latitude, longitude'."
    }, status: 201

  rescue Game::GameError 
    render json: { error: 'Something went wrong. Please try again later.' }, status: 500
  end
  
  def update 
    debugger;
  end

  private 

  #TODO: extract error messages, possibly all error handling, to separate module, then internationalize messages
  def validate_user_presence
    if current_user.nil?
      render json: { error: 'Not found; post your email to /users to create a user' }, status: 422 and return 
    end
  end

  def validate_user_eligibility
    if current_user.winner? 
      render json: 
      {
        message: "Congratulations! It looks like you guessed correctly and are now a permanent winner. "\
                 "You guessed #{current_user.winning_guess.first}, #{current_user.winning_guess.last}, "\
                 "which is #{geocoder_name(*current_user.winning_guess)}. The actual location was latitude: "\
                 "#{current_game.latitude}, longitude: #{current_game.longitude}, which is #{current_game.name}. "\
                 "If you would like to play again, please register with a different email address."
      }, 
      status: 200 and return
    end

    if current_user.game_id
      render json: 
      { 
        error: "You already have a game in progress. Include 'game_id=#{current_user.game_id}' " \
               'with your other params in a PATCH request to resume play.' 
      }, 
      status: 422 and return
    end
  end

  # TODO: this doesn't really belong here; leaving it here for now for expediency's sake. 
  def geocoder_name(latitude, longitude)
    result = Geocoder.search([latitude, longitude]).first
    result.data['name']
  end

  def current_game
    @current_game ||= Game.find(current_user.game_id)
  end
end
