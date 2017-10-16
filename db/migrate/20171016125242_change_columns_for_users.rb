class ChangeColumnsForUsers < ActiveRecord::Migration
  def change
    change_column :users, :balance, :integer, default: 0
    change_column :users, :earn,    :integer, default: 0
    remove_column :users, :supports_user_pay
  end
end
