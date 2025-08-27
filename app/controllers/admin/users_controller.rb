class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @users = AdminUser.all
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: "User deleted successfully"
    end

    private

    def set_user
      @user = AdminUser.find(params[:id])
    end

    def user_params
      params.require(:admin_user).permit(:email, :role)
    end
end