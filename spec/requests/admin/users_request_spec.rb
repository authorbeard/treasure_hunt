require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do  
  describe '#index' do 
    let!(:admin_user)     { FactoryBot.create(:user, :admin) }
    let!(:non_admin_user) { FactoryBot.create(:user) }

    before do 
      2.times { FactoryBot.create(:user) }
    end

    it "lists all users when current user is admin" do 
      get admin_users_path, params: { email: admin_user.email } 

      expect(response).to have_http_status(200)
      expect(response.body).to include(User.all.to_json)
    end

    it "responds with error message if user is not admin" do 
      get admin_users_path, params: { email: non_admin_user.email } 

      expect(response).to have_http_status(401)
      expect(response.body).to include("You are not authorized to access this page.")
    end
  end
end