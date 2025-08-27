class RegistrationsController < ApplicationController
  skip_before_action :require_login
  def new
    @user = AdminUser.new
  end

  def create
    @user = AdminUser.new(user_params)
    if @user.save
      flash[:notice] = "Register success. Please login."
      redirect_to login_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:admin_user).permit(:username, :email, :password, :password_confirmation, :avatar)
  end
end
