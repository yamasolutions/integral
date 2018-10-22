class AddImageToPages < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_pages, :image_id, :integer
    add_index :integral_pages, :image_id
  end
end
