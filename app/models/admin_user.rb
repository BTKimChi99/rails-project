class AdminUser < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

    validates :email, presence: true,
                    uniqueness: { case_sensitive: false, message: "Email already in use" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email syntax is incorrect" }
    validates :password,
                length: { minimum: 8, message: "Password must be at least 8 characters" },
                format: { with: /(?=.*[a-z])(?=.*[A-Z])(?=.*\W)/,
                          message: "Password must contain at least 1 uppercase letter, 1 lowercase letter and 1 special character" },
                if: -> { password.present? }
    validates :username,
      presence: { message: "Cannot be left blank" },
      uniqueness: { case_sensitive: false, message: "Username already in use" },
      format: { with: /\A[a-zA-Z0-9]+\z/, message: "Only letters and numbers are allowed" }
    validates :password_confirmation,
                presence: { message: "Cannot be left blank" },
                confirmation: { case_sensitive: true }

  def generate_password_reset_token!
    token = SecureRandom.urlsafe_base64
    update!(
      reset_password_token: token,
      reset_password_sent_at: Time.current
    )
    token
  end

  def password_reset_token_valid?
    reset_password_sent_at > 2.hours.ago
  end

  def reset_password!(password)
    update!(
      password: password,
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end
end
