class Admin::UsersController < Admin::BaseController
  def index 
    render json: User.all 
  end
end