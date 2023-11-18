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
      expect(response.body).to include("Congratulations! It looks like you guessed correctly and are now a permanent winner.")
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

    it 'greets the player' do
      allow(Game).to receive(:generate_new).and_return(game) 

      post games_path(email: player1.email)

      expect(response).to be_successful
      expect(response.body).to include("Welcome to game #{game.id}, #{player1.name}.")
    end

    it 'assigns the player to the newly-created game' do 
      allow(Game).to receive(:generate_new).and_return(game) 

      post games_path(email: player1.email)

      expect(player1.reload.game_id).to eq(game.id)
    end
  end

  describe "#update" do 
    before do 
      player1.update(game_id: game.id)
    end
    
    it 'checks for the presence of a user email' do 
      patch game_path(game.id)

      expect(response).to have_http_status(422)
    end

    it 'responds with instructions if user not found' do 
      patch game_path(game.id), params: { email: 'whatever@example.com' }

      expect(response).not_to be_successful
      expect(response.body).to include('Not found; post your email to /users to create a user')
    end

    it 'responds with congratulations if user has won a game already' do 
      player1.update(winning_guess: [1, 0])

      expect do 
        patch game_path(game.id), params: { email: player1.email }
      end.not_to change(Game, :count)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Congratulations! It looks like you guessed correctly and are now a permanent winner.")
    end

    it 'responds with an error if the user has a game and attempts to play a new one' do 
      other_game = create(:game)

      patch game_path(other_game.id), params: { email: player1.email }

      expect(response).not_to be_successful
      expect(response).to have_http_status(422)
      expect(response.body).to include("You're not playing game #{other_game.id}.")
    end

    it 'returns an error if user has guessed 5 times in the last hour' do 
      allow(User).to receive(:find_by).and_return(player1)
      allow(player1).to receive(:rate_limited?).and_return(true)

      patch game_path(game.id), params: { email: player1.email }

      expect(response).not_to be_successful
      expect(response).to have_http_status(429)
      expect(response.body).to include("You can guess again in #{Time.now + 1.hour}" )
    end

    it 'checks whether the user has guessed correctly' do 
      allow(Game).to receive(:find).with(game.id).and_return(game)
      allow(game).to receive(:play).with('1,0').and_call_original

      patch game_path(game.id), params: { email: player1.email, coordinates: '1,0' } 

      expect(game).to have_received(:play).with('1,0')
    end

    it 'informs the user of their distance if they guess incorrectly' do 
      allow(Game).to receive(:find).with(game.id).and_return(game)
      allow(game).to receive(:distance_from).and_return(5000)

      patch game_path(game.id), params: { email: player1.email, coordinates: '1,0' }

      expect(response).to be_successful 
      expect(response.body).to include("Sorry, try again. you are 5000km away.")
    end

    it 'records the user as a winner if they guess correctly' do
      allow(Game).to receive(:find).with(game.id).and_return(game)
      allow(User).to receive(:find_by).and_return(player1)
      allow(game).to receive(:distance_from).and_return(0.5)
      allow(player1).to receive(:record_win).and_call_original

      patch game_path(game.id), params: { email: player1.email, coordinates: '1,0' }

      expect(player1).to have_received(:record_win).with('1,0')
      expect(player1.reload.winner?).to be true
    end
  end
end