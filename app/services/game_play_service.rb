class GamePlayService 
  attr_reader :game, :player, :coordinates, :success, :message, :status

  def self.play
    new.tap { |g| g.play }
  end

  def initialize(game, player, coordinates)
    @game = game
    @player = player
    @coordinates = coordinates
  end

  def play 
    run_validations 
    take_turn 
  end

  private 

  def run_validations
    return if user_already_won
    return if user_playing_wrong_game
    return if user_is_rate_limited
  end

  def take_turn
    player.log_guess
    result = game.play(coordinates)
    @success, @message = result[:success], result[:message]
    if result[:success]
      player.record_win(coordinates, result[:distance])
      send_win_notification(result[:message])
    end
  end

  def user_already_won
    if player.winner? 
      @success = true
      @message = I18n.t(
          'game.permanent_winner',
          winning_lat: current_user.winning_guess.first, 
          winning_lng: current_user.winning_guess.last,
          geo_name: geocoder_name(current_user.winning_guess),
          game_lat: current_game.latitude,
          game_lng: current_game.longitude
        )
      }
    end
  end

  def user_playing_wrong_game
    if player.game_id != game.id
      @success = false
      @message = I18n.t('game.errors.wrong_game', game_id: params[:id]) 
      @status = 422
    end
  end

  user_is_rate_limited
    if current_user.rate_limited?
      next_avail = current_user.next_available_guess_time.localtime.strftime("%a, %B %d, %Y, %H:%M:%S %Z")
      @success = false
      @message = "You're out of guesses for now. You get 5 per hour. Next available: #{next_avail}." 
      @status = 429
    end
  end
end