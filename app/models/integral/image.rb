module Integral
  # Represents an image uploaded by a user
  class Image < ApplicationRecord
    before_save :touch_list_items

    acts_as_paranoid # Soft-deletion

    validates :file, presence: true
    validates :title, presence: true, length: { minimum: 5, maximum: 50 }
    validates :description, length: { maximum: 160 }

    mount_uploader :file, ImageUploader

    # Delegations
    delegate :url, to: :file

    # Associations
    has_many :list_items

    # Version Tracking
    has_paper_trail versions: { class_name: 'Integral::ImageVersion' }

    # Scopes
    scope :search, ->(query) { where('lower(title) LIKE ?', "%#{query.downcase}%") }

    # @return [String] represents the dimensions of the original image
    def dimensions
      "#{width}x#{height}px" if width && height
    end

    private

    def touch_list_items
      list_items.find_each(&:touch)
    end
  end
end
