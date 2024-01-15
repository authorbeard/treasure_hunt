class Admin::BaseController < ApplicationController  
  before_action :validate_admin
  
  private 

  def admin_user 
    @admin_user ||= User.admin.find_by(email: permitted_params[:email])
  end

  def validate_admin
    render json: :bad_request and return unless admin_user
  end
end
