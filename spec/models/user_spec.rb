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

    it "returns the user's email, without the domain, username is not present" do
      user = create(:user, email: 'email@example.com', username: nil)

      expect(user.name).to eq('email')
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

  describe "#rate_limited?" do
    it 'returns true if the user has guessed 5 times in the last hour' do
      user = create(:user)
      5.times { create(:user_guess, user: user) }

      expect(user.rate_limited?).to be true
    end

    it 'returns false if the user has guessed less than 5 times in the last hour' do 
      user = create(:user)
      create(:user_guess, :expired, user:user)
      4.times { create(:user_guess, user: user) }

      expect(user.rate_limited?).to be false

    end
  end

  describe "#next_available_guess_time" do 
    it "if the user is rate_limited, returns the time of the first guess plus one hour and one second" do 
      user = create(:user)
      5.times { create(:user_guess, user: user) }

      next_available_placeholder = user.user_guesses.first.created_at

      expect(user.next_available_guess_time).to be >= next_available_placeholder
    end
  end

  describe "#log_guess" do
    it 'creates a new user_guess record' do
      user = create(:user)

      expect do
        user.log_guess
      end.to change(UserGuess, :count).by(1)
    end
  end

  describe "#email_handle" do
    it "strips the domain from the user's email" do
      user = create(:user, email: 'someone@example.com')

      expect(user.email_handle).to eq('someone')
    end
  end
end
