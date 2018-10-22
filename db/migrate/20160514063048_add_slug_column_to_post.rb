class AddSlugColumnToPost < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_posts, :slug, :string
    add_index :integral_posts, :slug, unique: true
  end
end
