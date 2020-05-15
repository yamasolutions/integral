module Integral
  # Represents an image uploaded by a user
  class Image < ApplicationRecord
    before_save :touch_list_items

    acts_as_integral backend_main_menu: { order: 40 } # Integral Goodness
    acts_as_paranoid # Soft-deletion

    validates :file, presence: true
    validates :title, presence: true, length: { minimum: 5, maximum: 50 }
    validates :description, length: { maximum: 160 }

    mount_uploader :file, ImageUploader
    process_in_background :file

    # Delegations
    delegate :url, to: :file

    # Associations
    has_many :list_items

    # Version Tracking
    has_paper_trail class_name: 'Integral::ImageVersion'

    # Scopes
    scope :search, ->(query) { where('lower(title) LIKE ?', "%#{query.downcase}%") }

    # @return [String] represents the dimensions of the original image
    def dimensions
      "#{width}x#{height}px" if width && height
    end

    # @return [Hash] the instance as a list item
    def to_list_item
      {
        id: id,
        title: title,
        subtitle: description,
        description: description,
        image: file
      }
    end

    # @return [Hash] listable options to be used within a RecordSelector widget
    def self.listable_options
      {
        record_title: I18n.t('integral.backend.record_selector.images.record'),
        selector_path: Engine.routes.url_helpers.list_backend_images_path,
        selector_title: I18n.t('integral.backend.record_selector.images.title')
      }
    end

    def self.integral_icon
      'image'
    end

    def self.integral_backend_main_menu_item
      {
        icon: integral_icon,
        order: 40,
        label: model_name.human.pluralize,
        url: url_helpers.send("backend_img_index_url"),
        authorize_class: self,
        authorize_action: :index,
        list_items: [
          { label: I18n.t('integral.navigation.dashboard'), url: url_helpers.send("backend_img_index_url"), authorize_class: self, authorize_action: :index },
          { label: I18n.t('integral.actions.create'), url: url_helpers.send("new_backend_img_url"), authorize_class: self, authorize_action: :new },
          { label: I18n.t('integral.navigation.listing'), url: url_helpers.send("list_backend_img_index_url"), authorize_class: self, authorize_action: :list },
        ]
      }
    end

    private

    def touch_list_items
      list_items.find_each(&:touch)
    end

    # Override CarrierwaveBackgrounder Method
    #
    # CarrierwaveBackgrounder should not be attempting to process images when processing is
    # disabled through Carrierwave
    def enqueue_file_background_job?
      !remove_file? && !process_file_upload && file_updated? && ImageUploader.enable_processing
    end
  end
end
