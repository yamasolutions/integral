class AddImageIdToPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :integral_posts, :image
    remove_column :integral_posts, :image_processing

    add_column :integral_posts, :image_id, :integer
    add_index :integral_posts, :image_id
  end
end
