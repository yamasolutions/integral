class AddStatusToIntegralUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :integral_users, :status, :integer, default: 0
  end
end
