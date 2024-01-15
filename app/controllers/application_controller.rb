class ApplicationController < ActionController::API
  before_action :check_for_user_params

  private 
  
  def check_for_user_params
    render json: { error: "You need to supply an email address." }, status: 422 and return unless permitted_params[:email]
  end

  def current_user 
    @user ||= User.find_by(email: permitted_params[:email])
  end

  def permitted_params
    params.permit(:email, :username, :coordinates)
  end
end
