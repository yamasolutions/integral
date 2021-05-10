module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages Page filtering & sorting
    class BlockListsGrid
      include Datagrid

      scope do
        BlockEditor::BlockList.where(listable_id: nil, listable_type: nil).order('updated_at DESC')
      end

      filter(:title) do |value|
        search(value)
      end

      column(:name, order: :name)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
