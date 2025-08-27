class PasswordResetMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: "Reset pasword.")
  end
end
