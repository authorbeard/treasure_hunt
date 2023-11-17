require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#index' do 
    it "is accessible to admin users" do 
      admin_user = FactoryBot.create(:user, :admin)
      non_admin_user = FactoryBot.create(:user)

      get users_path, params: { email: admin_user.email } 
      expect(response).to have_http_status(200)
    end

    it "is not accessible to non-admin users" do
      non_admin_user = FactoryBot.create(:user)

      get users_path, params: { email: non_admin_user.email } 
      
      expect(response).not_to be_successful
      expect(response).to have_http_status(401)
    end
  end

  describe '#create' do
    it 'creates a user if supplied with a unique email address' do 
      expect do 
        post users_path(email: 'someone@whatever.dude')
      end.to change(User, :count).by(1)
    end

    it 'creates a user if supplied with a unique email address and unique username' do 
      expect do 
        post users_path(email: 'someone@whatever.dude', username: 'someone')
      end.to change(User, :count).by(1)

      body = JSON.parse(response.body)
      expect(body['username']).to eq('someone')
    end

    it 'returns an error if supplied with a non-unique email address' do
      existing_user = create(:user, email: 'notunique@bruh.io', username: 'notunique')

      expect do
        post users_path(email: 'notunique@bruh.io', username: 'unique')
      end.not_to change(User, :count)

      expect(response).not_to be_successful
      expect(response).to have_http_status(422)
    end
  end
end