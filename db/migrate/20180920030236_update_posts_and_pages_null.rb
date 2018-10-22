class UpdatePostsAndPagesNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :integral_pages, :status, false
    change_column_null :integral_posts, :status, false
  end
end
