require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "#name" do 
    it "returns the username if present" do
      user = create(:user, username: 'someone')

      expect(user.name).to eq('someone')
    end

    it "returns the email if username is not present" do
      user = create(:user, email: 'email@example.com', username: nil)

      expect(user.name).to eq('email@example.com')
    end
  end

  describe "#winner?" do 
    it 'returns true if the user has a winning guess' do 
      user = create(:user, winning_guess: {lat: 1, lng: 1})

      expect(user.winner?).to be true
    end
  end

  describe "#record_win" do
    it 'updates the user with the winning guess' do
      user = create(:user)
      guess = "1,1"

      user.record_win(guess)

      expect(user.reload.winning_guess).to match_array([1,1])
      expect(user.winner?).to be true
    end
  end
end
