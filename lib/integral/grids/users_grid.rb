module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages User filtering & sorting
    class UsersGrid
      include Datagrid

      scope do
        Integral::User.all.order('name DESC')
      end

      filter(:search) do |value|
        search(value)
      end

      filter(:status, multiple: true) do |value|
        where(status: value)
      end

      column(:name, order: :name)
      column(:email, order: :email)
      column(:status, order: :status)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
