class RemoveIntegralImages < ActiveRecord::Migration[6.1]
  def change
    drop_table :integral_images
    drop_table :integral_image_versions
  end
end
