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
      user = create(:user, email: 'email@example.com')

      expect(user.name).to eq('email@example.com')
    end
  end
end
