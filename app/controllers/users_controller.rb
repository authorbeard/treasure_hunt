class UsersController < ApplicationController
  def index 
    render json: { message: "UsersController#index" }
  end
end
