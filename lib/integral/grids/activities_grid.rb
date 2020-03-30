module Integral
  # Grids to manage displaying of data when filtering & sorting is required
  module Grids
    # Manages Activity filtering & sorting
    class ActivitiesGrid
      include Datagrid

      scope do
        fields = [:id, :item_type, :item_id, :event, :whodunnit, :created_at]
        scope = Integral::PageVersion.select(fields).all
        [Integral::PostVersion,
         Integral::ListVersion,
         Integral::ImageVersion,
         Integral::UserVersion].concat(Integral.additional_version_classes).each do |version|
          scope = scope.union(version.select(fields).all)
        end
        scope = scope.order('created_at DESC')
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
