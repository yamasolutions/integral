module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages List filtering & sorting
    class ListsGrid
      include Datagrid

      scope do
        Integral::List.where(hidden: false).order('title DESC')
      end

      filter(:search) do |value|
        search(value)
      end

      column(:title, order: :title)
      column(:description, order: :description)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
