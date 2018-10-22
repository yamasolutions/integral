class AddAdminToIntegralUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :integral_users, :admin, :boolean, default: false
  end
end
