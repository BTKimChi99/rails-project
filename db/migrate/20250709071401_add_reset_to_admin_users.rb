class AddResetToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_users, :reset_password_token, :string
    add_column :admin_users, :reset_password_sent_at, :datetime
  end
end
