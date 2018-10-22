class AddParentToPages < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_pages, :parent_id, :integer
  end
end
