class GamesController < ApplicationController
  # before_action :validate_user_not_yet_winner
  before_action :validate_user_not_already_playing, only: [:create]
  # before_action :validate_user_playing_correct_game, only: [:update]
  # before_action :validate_user_not_rate_limited, only: [:update]

  def create
    game = Game.generate_new
    current_user.update(game_id: game.id)

    #TODO: Extract this message to its own method or to another class.
    render json: {
      message: I18n.t('.models.game.welcome'), game_id: game.id, name: current_user.name,
    }, status: 201

  rescue Game::GameError 
    render json: { error: I18n.t('errors.generic_500') }, status: 500
  end
  
  def update
    game_status = play_game 

    if game_status.sucess
      render json: { message: game_status.message }, status: 200
    else
      render json: { error: game_status.message }, status: game_status.status
    end

    # result = current_game.play(coordinates)
    # current_user.record_win(coordinates, result[:distance]) if result[:success]
    # send_win_notification(result[:message]) if result[:success]
    # render json: {message: result[:message] }, status: 200
  end

  private 

  # #TODO: extract error messages, possibly all error handling, to separate module, then internationalize messages
  # def validate_user_presence
  #   if current_user.nil?
  #     debugger;
  #     render json: { error: 'Not found; post your email to /users to create a user' }, status: 422 and return 
  #   end
  # end

  # def validate_user_not_yet_winner
  #   if current_user.winner? 
  #     render json: 
  #     {
  #       message: I18n.t(
  #         'game.permanent_winner',
  #         winning_lat: current_user.winning_guess.first, 
  #         winning_lng: current_user.winning_guess.last,
  #         geo_name: geocoder_name(current_user.winning_guess),
  #         game_lat: current_game.latitude,
  #         game_lng: current_game.longitude
  #       )
  #     }, 
  #     status: 200 and return
  #   end
  # end

  def validate_user_not_already_playing
    if current_user.game_id
      render json: 
      { 
        error: I18n.t('game.errors.game_in_progress', game_id: current_user.game_id)
      }, 
      status: 422 and return
    end
  end

  def validate_user_playing_correct_game
    if current_user.game_id != params[:id].to_i
      render json: { 
        error: I18n.t('game.errors.wrong_game', game_id: params[:id]) 
      }, 
      status: 422 and return
    end
  end

  def validate_user_not_rate_limited
    if current_user.rate_limited?
      next_avail = current_user.next_available_guess_time.localtime.strftime("%a, %B %d, %Y, %H:%M:%S %Z")
      render json: { 
        error: "You're out of guesses for now. You get 5 per hour. Next available: #{next_avail}." 
      }, status: 429 and return
    
    else
      log_guess
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

  # TODO: This should eventually be extracted to a service object or something similar.
  def log_guess
    current_user.log_guess
  end

  def coordinates
    permitted_params[:coordinates]
  end

  def send_win_notification(msg)
    WinNotificationMailer.with(
      player: current_user,
      game: current_game,
      message: msg
    ).notify_winner.deliver_now
  end

  def permitted_params
    params.permit(:email, :coordinates)
  end

  def play_game 
    GamePlayService.play(current_game, current_user, coordinates)
  end
end
