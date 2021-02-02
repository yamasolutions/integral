class CreateIntegralStorageFiles < ActiveRecord::Migration[6.0]
  # The largest text column available in all supported RDBMS is
  # 1024^3 - 1 bytes, roughly one gibibyte.  We specify a size
  # so that MySQL will use `longtext` instead of `text`.  Otherwise,
  # when serializing very large objects, `text` might not be big enough.
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :integral_files do |t|
      t.string :title
      t.string :description
      t.datetime :deleted_at

      t.timestamps null: false
    end

    create_table :integral_file_versions do |t|
      t.string   :item_type, {:null=>false}
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object, limit: TEXT_BYTES
      t.text     :object_changes, limit: TEXT_BYTES
      t.datetime :created_at
    end
    add_index :integral_file_versions, %i(item_type item_id)

    Integral::Storage::File.connection.execute("ALTER SEQUENCE integral_files_id_seq RESTART WITH #{Integral::Image.last.id + 1}")
  end
end
