class UsersController < ApplicationController
  def index
    if user && user.is_admin 
      render json: User.all
    else 
      render json: { error: "Unauthorized" }, status: 401
    end
  end

  def create 
    if user.valid? 
      user.save!
      render json: user, status: 201
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  private 
  # NOTE: Because the task description explicitly says to use email as auth, 
  # I'm skipping the usual before_action methods and general pattern here, in favor
  # of a boolean (is_admin) that is set in the database, and that's only checked by
  # this endpoint for now. 

  def user 
    @user ||= User.find_or_initialize_by(user_params)
  end

  def user_params 
    params.permit(:email, :username)
  end
end
