class UsersController < ApplicationController
  before_action :validate_params

  def index
    if user.is_admin 
      render json: User.all
    else 
      render json: { error: "Unauthorized" }, status: 401
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

  def validate_params 
    render json: { error: "You need to supply an email address." }, status: 422 and return unless user_params[:email]
  end

  def user 
    @user ||= User.find_by(user_params)
  end

  def new_user
    @new_user ||= User.new(user_params)
  end

  def user_created
    {
      message: "Welcome, #{new_user.name}. Include your email as a url param with future guesses",
      username: new_user.username,
      email: new_user.email
    }
  end

  def user_params 
    params.permit(:email, :username)
  end
end
