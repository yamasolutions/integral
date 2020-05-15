module Integral
  # Represents a generic list such as a gallery or menu
  class List < ApplicationRecord
    include Notification::Subscribable
    default_scope { includes(:list_items) }

    acts_as_integral backend_main_menu: { order: 50 } # Integral Goodness
    acts_as_paranoid # Soft-deletion

    # Associations
    has_many :list_items

    # Validations
    validates :title, presence: true, uniqueness: true
    validates :list_item_limit, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates_associated :list_items
    validate :validate_list_item_limit
    before_destroy :validate_unlocked

    # Nested forms
    accepts_nested_attributes_for :list_items, reject_if: :all_blank, allow_destroy: true

    # Version Tracking
    has_paper_trail class_name: 'Integral::ListVersion'

    # Scopes
    scope :visible, -> { where(hidden: false) }
    scope :hidden, -> { where(hidden: true) }
    scope :search, ->(search) { where('lower(title) LIKE ?', "%#{search.downcase}%") }

    # Duplicates the list including all attributes, list items and list item children
    #
    # @return [List] Unsaved cloned list
    def dup
      new_list = super()

      list_items.each do |list_item|
        new_list_item = list_item.dup

        if list_item.has_children?
          list_item.children.each do |child|
            new_list_item.children << child.dup
          end
        end

        new_list.list_items << new_list_item
      end

      new_list
    end

    def self.integral_icon
      'list'
    end

    private

    def validate_unlocked
      return unless locked?

      errors.add(:locked, 'Cannot delete a locked item')
      throw(:abort)
    end

    def validate_list_item_limit
      return if list_item_limit.zero?
      return if list_items.size <= list_item_limit

      errors.add(:list_items, "Too many list items, the maximum amount is #{list_item_limit}.")
      throw(:abort)
    end
  end
end
