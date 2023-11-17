require 'rails_helper'

RSpec.describe GamesController, type: :request do
  let(:player1) { create(:user) }

  describe '#create' do 
    it 'checks for the presence of a user email' do 
      post games_path

      expect(response).to have_http_status(422)
    end
  end
end