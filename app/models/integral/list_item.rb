module Integral
  # Represents an item within a particular list
  class ListItem < ApplicationRecord
    # Default scope orders by priority and includes children
    default_scope { includes(:children).includes(:image).order(:priority) }

    # Associations
    belongs_to :list, optional: true, touch: true
    belongs_to :image, optional: true
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

    # @return [Array] list of types available for a list item
    def self.types_collection
      collection = [
        [I18n.t('integral.backend.lists.items.type.basic'), 'Integral::Basic', data: { true_value: 'Integral::Basic' }],
        [I18n.t('integral.backend.lists.items.type.link'), 'Integral::Link', data: { true_value: 'Integral::Link' }]
      ]

      ActsAsListable.objects.each do |listable|
        object_data = {
          icon: listable.listable_options[:icon],
          object_type: listable.to_s,
          record_selector: listable.to_s.parameterize,
          true_value: 'Integral::Object'
        }

        collection << [listable.listable_options[:record_title], listable.to_s, data: object_data]
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

    def validate_child_absence
      return if list.nil? || list.children?
      return if children.empty?

      errors.add(:children, 'Children cannot be added to this list.')
      throw(:abort)
    end
  end
end
