require 'rails_helper'

RSpec.describe GamesController, type: :request do
  let(:player1) { create(:user) }

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

    it 'creates a new game if the requests passes all validations' do 
      game = create(:game)
      allow(Game).to receive(:generate_new).and_return(game) 
      
      post games_path(email: player1.email)
      expect(Game).to have_received(:generate_new)
    end

    it 'returns the game id and instructions for use in the response' do
      game = create(:game)
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