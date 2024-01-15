class ApplicationController < ActionController::API
  before_action :ensure_user

  private 
  
  # NOTE: Only checking that request includes valid email address for now, 
  # as this is an MVP version and only the presence of a registered email 
  # address is mentioned in the params. 
  # Not enough information yet to begin implementing proper auth, including 
  # whether anyting appropriately robust is needed. 

  def ensure_user
    render json: { error: "You need to supply an email address." }, status: 422 and return unless permitted_params[:email]
  end

  def current_user 
    @user ||= User.find_by(email: permitted_params[:email])
  end

  def permitted_params
    params.permit(:email)
  end
end
