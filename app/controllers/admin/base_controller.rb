class Admin::BaseController < ApplicationController  
  before_action :validate_admin
  
  private 

  def validate_admin
    render json: { error: "You are not authorized to access this page." }, status: 401 and return unless current_user.is_admin
  end
end
