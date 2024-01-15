class UsersController < ApplicationController
  def index
    if winners?
      render json: User.formatted_winners
    else
      handle_index_request
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
  
  def new_user
    @new_user ||= User.new(email: permitted_params[:email], username: permitted_params[:username])
  end

  def user_created
    {
      message: "Welcome, #{new_user.email}. Include your email as a url param with future guesses",
      username: new_user.username,
      email: new_user.email
    }
  end

  def permitted_params
    params.permit(:email, :username, :filters)
  end

  def winners?
    permitted_params[:filters] == 'winners'
  end

  def formatted_current_user
    current_user.attributes.except('id', 'created_at', 'updated_at').to_json
  end

  def handle_index_request
    if current_user.is_admin 
      redirect_to admin_users_url and return
    else
      render json: formatted_current_user
    end
  end
end 
