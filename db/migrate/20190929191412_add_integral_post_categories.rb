class AddIntegralPostCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :integral_categories do |t|
      t.string :title
      t.string :description
      t.string :slug, unique: true

      t.timestamps null: false
    end

    add_reference :integral_posts, :category, index: true
  end
end
