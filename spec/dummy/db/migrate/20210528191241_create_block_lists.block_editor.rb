# This migration comes from block_editor (originally 20210312032114)
class CreateBlockLists < ActiveRecord::Migration[6.1]
  def change
    create_table :block_editor_block_lists do |t|
      t.string :name
      t.text :content
      t.boolean :active, default: false
      t.references :listable, polymorphic: true
      t.timestamps
    end
  end
end
