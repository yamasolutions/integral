class AddViewCountToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_posts, :view_count, :integer, default: 0
  end
end
