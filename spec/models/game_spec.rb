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
  end
end