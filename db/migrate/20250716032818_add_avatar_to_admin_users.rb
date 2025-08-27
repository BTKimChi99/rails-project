class AddAvatarToAdminUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_users, :avatar, :string
  end
end
