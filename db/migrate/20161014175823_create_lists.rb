class CreateLists < ActiveRecord::Migration[4.2]
  def change
    create_table :integral_lists do |t|
      t.string    "title", :null => false
      t.text      "description"
      t.boolean   "locked"
      t.string    "html_classes"
      t.string    "html_id"
    end

    create_table "integral_list_items", :force => true do |t|
      t.integer "list_id"
      t.string  "title"
      t.text  "description"
      t.string  "subtitle"
      t.string  "url"
      t.integer  "image_id"
      t.string  "target"
      t.string  "html_classes"
      t.integer "priority"
      t.integer "object_id"
      t.string "type"
      t.string "object_type"
    end

    create_table "integral_list_item_connections", :force => true, :id => false do |t|
      t.integer "parent_id", :null => false
      t.integer "child_id", :null => false
    end
  end
end
