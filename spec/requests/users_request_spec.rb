require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#index' do 
    it "is accessible to admin users" do 
      admin_user = FactoryBot.create(:user, :admin)
      non_admin_user = FactoryBot.create(:user)

      get users_path, params: { user: { email: admin_user.email } }
      expect(response).to have_http_status(200)
    end

    it "is not accessible to non-admin users" do
      non_admin_user = FactoryBot.create(:user)

      get users_path, params: { user: { email: non_admin_user.email } }
      
      expect(response).not_to be_successful
      expect(response).to have_http_status(401)
    end
  end
end