class AddDeletedAtToLists < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_lists, :deleted_at, :datetime
    add_index :integral_lists, :deleted_at
  end
end
