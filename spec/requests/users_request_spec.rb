require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe '#index' do 
    it "is accessible to admin users" do 
      admin_user = FactoryBot.create(:user, :admin)
      non_admin_user = FactoryBot.create(:user)

      get users_path, headers: { "Authorization" => admin_user.email }
      expect(response).to have_http_status(200)
    end

    it "is not accessible to non-admin users" do
      non_admin_user = FactoryBot.create(:user)

      get user_path, headers: {"Authorization" => non_admin_user.email }
      expec(response).not_to be_successful
    end
  end
end