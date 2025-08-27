class HomeController < ApplicationController
    layout "main"
  def index
    @user = current_admin_user
  end

  def edit
    @user = current_admin_user
  end

  def update
    @user = current_admin_user
    if @user.update(user_params)
      redirect_to home_path, notice: "Information has been updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_admin_user
  end

  def user_params
    params.require(:admin_user).permit(:email, :role)
  end
end
