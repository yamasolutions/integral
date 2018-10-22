class CreateIntegralImages < ActiveRecord::Migration[4.2]
  def change
    create_table :integral_images do |t|
      t.string :title
      t.string :description
      t.string :file
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
