
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    
    it 'uses the email address as username if none provided' do 
      user = build(:user, username: nil)

      expect(user.save).to be true
    end
  end
end
