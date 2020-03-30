module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages Activity filtering & sorting
    class ActivitiesGrid
      include Datagrid

      scope do
        # TODO - Be nice to be able to write this so that it loops over 'tracked' models - meaning the host app doesn't need to override this file when the track new (non integral) models
        Integral::UserVersion.select(:id, :item_type, :item_id, :event, :whodunnit, :created_at).all.
          union(Integral::PageVersion.select(:id, :item_type, :item_id, :event, :whodunnit, :created_at).all).
          union(Integral::PostVersion.select(:id, :item_type, :item_id, :event, :whodunnit, :created_at).all).
          union(Integral::ListVersion.select(:id, :item_type, :item_id, :event, :whodunnit, :created_at).all).
          union(Integral::ImageVersion.select(:id, :item_type, :item_id, :event, :whodunnit, :created_at).all).
          order('created_at DESC')
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

      filter(:created_at) do |value|
        where("created_at < ?", value)
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
