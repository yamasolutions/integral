module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages List filtering & sorting
    class PostsGrid
      include Datagrid

      scope do
        Integral::Post.all.order('title DESC')
      end

      filter(:title) do |value|
        search(value)
      end

      filter(:status, multiple: true) do |value|
        where(status: value)
      end

      filter(:user, multiple: true) do |value|
        where(user: value)
      end

      filter(:category, multiple: true) do |value|
        where(category_id: value)
      end

      column(:title, order: :title)
      column(:category, order: :category_id)
      column(:status, order: :status)
      column(:view_count, order: :view_count)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
