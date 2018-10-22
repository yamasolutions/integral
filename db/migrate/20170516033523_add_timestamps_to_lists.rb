class AddTimestampsToLists < ActiveRecord::Migration[4.2]
  def change
    add_timestamps(:integral_lists)
    add_timestamps(:integral_list_items)
  end
end
