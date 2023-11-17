require 'rails_helper'

RSpec.describe Game do
  describe "validations" do
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }

    it "sets the game's address based on latitude and longitude" do
      game = build(:game, address: nil)

      expect(game).to be_valid
      expect(game.save!).to be true 
      expect(game.reload.address).not_to be_nil
    end

    describe ".generate_new" do 
      it "generates random coordinates" do 
        allow(Game).to receive(:generate_coordinates).and_call_original

        Game.generate_new

        expect(Game).to have_received(:generate_coordinates)
      end

      it "generates a new game using the random coordinates" do 
        expect do 
          Game.generate_new
        end.to change(Game, :count).by(1)
      end

      it "raises a custom error if anything goes wrong" do
        allow(Game).to receive(:generate_coordinates).and_return(nil)

        expect do
          Game.generate_new
        end.to raise_error(Game::GameError)
      end
    end

    describe '#play' do 
      let(:coord_string) { "37.8073262, -122.4754017" }
      let(:game)         { create(:game) }

      it 'calculates distance from lat, lng string to the game coordinates' do
        allow(game).to receive(:distance_from).and_call_original

        game.play(coord_string)
        expect(game).to have_received(:distance_from).with(coord_string.split(',').map(&:to_f))
      end

      it 'checks that the guess coordinates are within 1km' do 
        allow(game).to receive(:distance_from).and_return(0.5)

        result = game.play(coord_string)
        expect(result[:success]).to be true
      end

      it 'informs the user of how far off they are if they guess incorrectly' do 
        allow(game).to receive(:distance_from).and_return(5000)
        
        result = game.play(coord_string)
        expect(result[:success]).to be false
        expect(result[:message]).to include('Sorry, try again. you are 5000km away.')
      end
    end
  end
end