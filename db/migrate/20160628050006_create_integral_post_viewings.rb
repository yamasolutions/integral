class CreateIntegralPostViewings < ActiveRecord::Migration[4.2]
  def change
    create_table :integral_post_viewings do |t|
      t.integer :post_id, index: true, foreign_key: true
      t.string :ip_address

      t.timestamps null: false
    end
  end
end
