class AddTemplatesToPages < ActiveRecord::Migration[4.2]
  def change
    add_column :integral_pages, :template, :string, default: 'default'
  end
end
