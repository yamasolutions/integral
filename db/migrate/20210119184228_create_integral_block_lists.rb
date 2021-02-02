class CreateIntegralBlockLists < ActiveRecord::Migration[6.0]
  # The largest text column available in all supported RDBMS is
  # 1024^3 - 1 bytes, roughly one gibibyte.  We specify a size
  # so that MySQL will use `longtext` instead of `text`.  Otherwise,
  # when serializing very large objects, `text` might not be big enough.
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :integral_block_lists do |t|
      t.string :name
      t.text :content
      t.boolean :active, default: false
      t.references :listable, polymorphic: true
      t.timestamps
    end

    create_table :integral_block_list_versions do |t|
      t.string   :item_type, {:null=>false}
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object, limit: TEXT_BYTES
      t.text     :object_changes, limit: TEXT_BYTES
      t.datetime :created_at
    end
    add_index :integral_block_list_versions, %i(item_type item_id)

    Integral::Post.unscoped.each do |resource|
      Integral::BlockEditor::BlockList.create!(content: resource.body, listable: resource, active: true)
    end

    Integral::Page.unscoped.each do |resource|
      Integral::BlockEditor::BlockList.create!(content: resource.body, listable: resource, active: true)
    end

    remove_column :integral_pages, :body
    remove_column :integral_posts, :body
  end
end
