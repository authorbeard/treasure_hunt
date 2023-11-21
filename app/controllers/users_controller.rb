class UsersController < ApplicationController
  def index
    if current_user.is_admin 
      render json: User.all
    else 
      render json: User.formatted_winners
    end
  end

  def create 
     if new_user.valid? 
      new_user.save!
      render json: user_created, status: 201
    else
      render json: { error: "There was a problem with your email address." }, status: 401
    end
  end

  private 
  # NOTE: Because the task description explicitly says to use email as auth, 
  # I'm skipping the usual before_action methods and general pattern here, in favor
  # of a boolean (is_admin) that is set in the database, and that's only checked by
  # this endpoint for now. 

  def new_user
    @new_user ||= User.new(email: allowed_params[:email], username: allowed_params[:username])
  end

  def user_created
    {
      message: "Welcome, #{new_user.email}. Include your email as a url param with future guesses",
      username: new_user.username,
      email: new_user.email
    }
  end
end
