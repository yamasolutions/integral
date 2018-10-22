class AddDraftingToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_posts, :published_at, :datetime
    add_column :integral_posts, :status, :integer, default: 0
  end
end
