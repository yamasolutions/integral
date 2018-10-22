class CreateIntegralPosts < ActiveRecord::Migration[4.2]
  def change
    create_table :integral_posts do |t|
      t.string :title
      t.string :description
      t.text :body
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
