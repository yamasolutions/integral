module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages User filtering & sorting
    class UsersGrid
      include Datagrid

      scope do
        Integral::User.all.order('name DESC')
      end

      filter(:name) do |value|
        search(value)
      end

      column(:name, order: :name)
      column(:email, order: :email)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
