module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages file filtering & sorting
    class FilesGrid
      include Datagrid

      scope do
        Integral::Storage::File.all.order('title DESC')
      end

      filter(:title) do |value|
        search(value)
      end

      column(:title, order: :title)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
