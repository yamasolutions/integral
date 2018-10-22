class AddDeletedAtToObjects < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_images, :deleted_at, :datetime
    add_index :integral_images, :deleted_at

    add_column :integral_pages, :deleted_at, :datetime
    add_index :integral_pages, :deleted_at

    add_column :integral_posts, :deleted_at, :datetime
    add_index :integral_posts, :deleted_at

    add_column :integral_users, :deleted_at, :datetime
    add_index :integral_users, :deleted_at
  end
end
