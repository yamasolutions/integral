module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages Page filtering & sorting
    class PagesGrid
      include Datagrid

      scope do
        Integral::Page.all.order('updated_at DESC')
      end

      filter(:title) do |value|
        search(value)
      end

      filter(:status, multiple: true) do |value|
        where(status: value)
      end

      column(:title, order: :title)
      column(:path, order: :path)
      column(:status, order: :status)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
