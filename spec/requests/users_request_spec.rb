require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#index' do 
    let(:admin_user)     { FactoryBot.create(:user, :admin) }
    let(:non_admin_user) { FactoryBot.create(:user) }

    before do 
      10.times { FactoryBot.create(:user) }
    end

    it "lists all users when admin user requests with just email" do 
      get users_path, params: { email: admin_user.email } 

      expect(response).to have_http_status(200)
      expect(response.body).to include(User.all.to_json)
    end

    it "lists winners if the user is not an admin" do
      winners = User.limit(5).tap{ |u| u.update(winning_guess: [1, 0]) }
      loser = User.where(winning_guess: nil).first

      get users_path, params: { email: non_admin_user.email } 

      expect(response).to be_successful
      ids = JSON.parse(response.body).map{ |u| u['id'] }  
      expect(ids).to match_array(winners.map(&:id) )
      expect(ids).not_to include(loser.id)
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

    it 'includes the user email and instructions for use in the response' do 
      post users_path(email: 'someone@example.com')

      expect(response.body).to include("Welcome, someone@example.com. Include your email as a url param with future guesses")
    end

    it 'returns an error if supplied with a non-unique email address' do
      existing_user = create(:user, email: 'notunique@bruh.io', username: 'notunique')

      expect do
        post users_path(email: existing_user.email, username: 'unique')
      end.not_to change(User, :count)

      expect(response).not_to be_successful
      expect(response).to have_http_status(401)
    end

    it 'returns an error if the email address param is missing' do 
      post users_path(username: 'unique')
  
      expect(response).to have_http_status(422)
      expect(response.body).to include('You need to supply an email address.')  
    end
  end
end