class AddFieldsToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :integral_lists, :list_item_limit, :integer, default: 0
    add_column :integral_lists, :hidden, :boolean, default: false
    add_column :integral_lists, :children, :boolean, default: false
  end
end
