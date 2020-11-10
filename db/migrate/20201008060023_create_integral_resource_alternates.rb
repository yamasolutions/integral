class CreateIntegralResourceAlternates < ActiveRecord::Migration[5.2]
  def change
    create_table :integral_resource_alternates do |t|
      t.references :alternate, polymorphic: true, index: false
      # (automated index name is too long)
      t.references :resource, polymorphic: true, index: { name: 'index_integral_resource_alternates_on_resource_type_id' }

      t.timestamps
    end

    add_column :integral_pages, :locale, :string
    add_column :integral_posts, :locale, :string
    add_column :integral_categories, :locale, :string

    remove_index :integral_posts, [:slug]
    add_index :integral_posts, [:slug, :locale], unique: true
  end
end
