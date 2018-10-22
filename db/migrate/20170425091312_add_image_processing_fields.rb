class AddImageProcessingFields < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_images, :file_processing, :boolean, null: false, default: true
    add_column :integral_users, :avatar_processing, :boolean, null: false, default: true
    add_column :integral_posts, :image_processing, :boolean, null: false, default: true
  end
end
