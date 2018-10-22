module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages Activity filtering & sorting
    class ActivitiesGrid
      include Datagrid

      scope do
        Integral::UserVersion.all.union(Integral::PageVersion.all).union(Integral::PostVersion.all).union(Integral::ListVersion.all).union(Integral::ImageVersion.all).order('created_at DESC')
      end

      filter(:user, multiple: true) do |value|
        where(whodunnit: value)
      end

      filter(:action, multiple: true) do |value|
        where(event: value)
      end

      filter(:object, multiple: true) do |value|
        where(item_type: value)
      end

      filter(:item_id, multiple: true) do |value|
        where(item_id: value)
      end

      column(:date, order: :created_at)
      column(:user, order: :whodunnit)
      column(:action, order: :event)
      column(:object, order: :item_type)
      column(:instance)
      column(:attributes_changed)
      column(:actions)
    end
  end
end
