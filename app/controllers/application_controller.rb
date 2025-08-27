class ApplicationController < ActionController::Base
  helper_method :current_admin_user

  before_action :require_login

  def current_admin_user
    @current_admin_user ||= AdminUser.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end

  def require_login
    unless current_admin_user
      redirect_to login_path, alert: "You need to log in first."
    end
  end
end
