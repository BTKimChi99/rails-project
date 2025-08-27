class AdminMailer < ApplicationMailer
  default from: "noreply@example.com"

  def password_reset(admin_user)
    @admin_user = admin_user
    @reset_url = edit_password_reset_url(token: @admin_user.reset_password_token)
    mail(to: @admin_user.email, subject: "Reset password Admin")
  end
end
