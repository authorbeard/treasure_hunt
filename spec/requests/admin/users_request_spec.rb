require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do  
  describe '#index' do 
    let(:admin_user)     { FactoryBot.create(:user, :admin) }
    let(:non_admin_user) { FactoryBot.create(:user) }

    before do 
      2.times { FactoryBot.create(:user) }
    end


end