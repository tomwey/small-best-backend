class AddMerchantIdToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :merchant_id, :integer
    add_index :admin_users, :merchant_id
  end
end
