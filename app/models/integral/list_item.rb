module Integral
  # Represents an item within a particular list
  class ListItem < ApplicationRecord
    # Default scope orders by priority and includes children
    default_scope { includes(:children).includes(:image).order(:priority) }

    # Associations
    belongs_to :list, optional: true, touch: true
    belongs_to :image, class_name: 'Integral::Storage::File', optional: true
    has_many :list_item_connections, foreign_key: 'parent_id'
    has_many :children, -> { order(:priority) }, through: :list_item_connections
    has_many :inverse_list_item_connections, class_name: "ListItemConnection", foreign_key: "child_id"
    # NOTE: A List Item only has one parent
    has_many :parents, :through => :inverse_list_item_connections

    # Validations
    validate :validate_child_absence

    # Nested forms
    accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true

    # Callbacks
    after_initialize :set_defaults
    after_commit :touch_parent, on: :update
    after_destroy :touch_parent
    after_touch :touch_list

    # @return [Array] list of types available for a list item
    def self.types_collection
      collection = [
        [I18n.t('integral.backend.lists.items.type.basic'), 'Integral::Basic', data: { true_value: 'Integral::Basic' }],
        [I18n.t('integral.backend.lists.items.type.link'), 'Integral::Link', data: { true_value: 'Integral::Link' }]
      ]

      ActsAsListable.objects.each do |listable|
        object_data = {
          object_type: listable.to_s,
          resource_selector: listable.to_s.parameterize,
          true_value: 'Integral::Object',
          resource_selector_title: 'Select resource..',
          resource_selector_url: Engine.routes.url_helpers.list_backend_posts_path(format: :json)
        }

        collection << [listable.model_name.human, listable.to_s, data: object_data]
      end

      collection
    end

    def object?
      false
    end

    def link?
      false
    end

    def basic?
      false
    end

    def has_children?
      children.present?
    end

    private

    def set_defaults
      self.type ||= 'Integral::Basic'
    end

    def touch_parent
      parent = parents.first
      parent.touch if parent.present? && parent.persisted?
    end

    def touch_list
      list.touch if list.present? && list.persisted?
    end

    def validate_child_absence
      return if list.nil? || list.children?
      return if children.empty?

      errors.add(:children, 'Children cannot be added to this list.')
      throw(:abort)
    end
  end
end
