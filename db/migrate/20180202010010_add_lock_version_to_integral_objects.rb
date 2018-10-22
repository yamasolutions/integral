class AddLockVersionToIntegralObjects < ActiveRecord::Migration[5.1]
  def change
    add_column :integral_lists, :lock_version, :integer
    add_column :integral_images, :lock_version, :integer
    add_column :integral_pages, :lock_version, :integer
    add_column :integral_posts, :lock_version, :integer
    add_column :integral_users, :lock_version, :integer
  end
end
