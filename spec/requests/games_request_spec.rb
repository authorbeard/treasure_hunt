require 'rails_helper'

RSpec.describe GamesController, type: :request do
  let(:player1) { create(:user) }
  describe '#new' do
    it 'creates a game if supplied with a unique email address' do
      expect do
        get new_game_path, params: { email: player1.email }
      end.to change(Game, :count).by(1)
    end
  end
end