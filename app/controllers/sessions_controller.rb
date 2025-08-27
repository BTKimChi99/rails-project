class SessionsController < ApplicationController
  skip_before_action :require_login
  def new
    if current_admin_user
      if current_admin_user.role == 1
        redirect_to admin_root_path
      else
        redirect_to home_path
      end
    end
  end

  def create
    user = AdminUser.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:admin_user_id] = user.id

      if user.role == 1
        redirect_to admin_root_path, notice: "Log in successfully"
      else
        redirect_to home_path, notice: "Log in successfully"
      end

    else
      flash[:alert] = "Incorrect email or password"
      redirect_to login_path
    end
  end


  def destroy
    session[:admin_user_id] = nil
    redirect_to login_path, notice: "Signed out."
  end
end
