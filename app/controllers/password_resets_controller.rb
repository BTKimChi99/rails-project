class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  def new
  end

  def create
    @user = AdminUser.find_by(email: params[:email])
    if @user
      token = @user.generate_password_reset_token!
      PasswordResetMailer.with(user: @user, token: token).reset_email.deliver_now
      redirect_to login_path, notice: "Password reset email sent."
    else
      flash.now[:alert] = "Email does not exist."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = AdminUser.find_by(reset_password_token: params[:token])
    if @user.nil? || !@user.password_reset_token_valid?
      redirect_to new_password_reset_path, alert: "Link is invalid or expired."
    end
  end

  def update
    # Debug log
    Rails.logger.info "==== PARAMS: #{params.inspect}"

    @user = AdminUser.find_by(reset_password_token: params[:token])

    if @user&.password_reset_token_valid?
      if @user.reset_password!(params[:password])
        Rails.logger.info "==== Password reset SUCCESS for user #{@user.email}"
        redirect_to login_path, notice: "Password reset successful!"
      else
        Rails.logger.info "==== Password reset FAILED for user #{@user.email}"
        flash.now[:alert] = "An error occurred while resetting password."
        render :edit, status: :unprocessable_entity
      end
    else
      Rails.logger.info "==== Invalid or expired token: #{params[:token]}"
      redirect_to new_password_reset_path, alert: "Link is invalid or expired."
    end
  end
end
