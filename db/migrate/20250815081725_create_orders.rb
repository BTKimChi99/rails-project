class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string  :code,            null: false
      t.string  :customer_name,   null: false
      t.string  :customer_phone,  null: false
      t.text    :customer_address, null: false
      t.decimal :total_amount, precision: 12, scale: 2, null: false, default: 0
      t.integer :status,          null: false, default: 0  # enum
      t.bigint  :assigned_to
      t.bigint  :assigned_by

      t.timestamps
    end

    add_index :orders, :code, unique: true
    add_index :orders, :status
    add_index :orders, :assigned_to
    add_index :orders, :assigned_by

    add_foreign_key :orders, :admin_users, column: :assigned_to
    add_foreign_key :orders, :admin_users, column: :assigned_by
  end
end
