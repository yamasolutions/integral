class AddRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :integral_roles do |t|
      t.string :name
    end

    create_table :integral_role_assignments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true
      t.timestamps null: false
    end
  end
end
