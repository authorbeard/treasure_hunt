require 'rails_helper'

RSpec.describe GamesController, type: :request do
  let(:player1) { create(:user) }
  let(:game)    { create(:game) }

  describe '#create' do 
    it 'checks for the presence of a user email' do 
      post games_path

      expect(response).to have_http_status(422)
    end

    it 'responds with instructions if user not found' do 
      post games_path(email: 'whatever@example.com')

      expect(response).not_to be_successful
      expect(response.body).to include('Not found; post your email to /users to create a user')
    end

    it 'responds with instructions if user has a game in progress already' do 
      player1.update(game: create(:game))

      post games_path(email: player1.email)

      expect(response).to have_http_status(422)
      expect(response.body).to include("You already have a game in progress. Include 'game_id=1' with your other params in a PATCH request to resume play.")
    end

    it 'responds with congratulations if user has won a game already' do 
      player1.update(game_id: game.id, winning_guess: [1, 0])

      expect do 
        post games_path(email: player1.email)
      end.not_to change(Game, :count)

      expect(response).to have_http_status(200)
      expect(response.body).to include(
        "Congratulations! It looks like you guessed correctly and are now a permanent winner. "\
        "You guessed latitude: 1, longitude: 0, Golden Gate Bridge. "\
        "The actual location was latitude: 37.79005325, longitude: -122.40079711635721, Flatiron Building. "\
        "If you would like to play again, please use a different email address."
      )
    end

    it 'returns a generic error if anything goes wrong with game creation' do 
      allow(Game).to receive(:generate_new).and_raise(Game::GameError)

      post games_path(email: player1.email)

      expect(response).not_to be_successful
      expect(response.body).to include('Something went wrong. Please try again later.')
    end

    it 'creates a new game if the requests passes all validations' do 
      allow(Game).to receive(:generate_new).and_return(game) 
      
      post games_path(email: player1.email)
      expect(Game).to have_received(:generate_new)
    end

    it 'returns the game id and instructions for use in the response' do
      allow(Game).to receive(:generate_new).and_return(game) 

      post games_path(email: player1.email)

      expect(response).to be_successful
      expect(response.body).to include(
        "Welcome, to game #{game.id}, #{player1.name}. To play, send a PATCH request to /games. "\
        "Be sure to include your email address, the game id and your coordinates as params, "\
        "using the keys email, game_id, and coordinates. Coordinates should be formatted as a string: 'latitude, longitude'."
      )
    end
  end
end