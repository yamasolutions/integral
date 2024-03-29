module Integral
  module Storage
    # Represents a file uploaded by a user
    class File < ApplicationRecord
      has_one_attached :attachment

      delegate :attached?, to: :attachment
      delegate :variant, to: :attachment
      delegate :representation, to: :attachment

      validates :title, presence: true, length: { maximum: 150 }
      validates :description, length: { maximum: 300 }

      acts_as_integral({
        icon: 'bi bi-cloud',
        notifications: { enabled: false },
        listable: { enabled: true },
        backend_main_menu: { order: 80 },
        backend_create_menu: { order: 80 }
      }) # Integral Goodness

      acts_as_paranoid # Soft-deletion

      has_paper_trail versions: { class_name: 'Integral::Storage::FileVersion' } # Version Tracking

      scope :search, ->(query) { where('lower(title) LIKE ?', "%#{query.downcase}%") }
      scope :search_by_types, ->(types) { joins(attachment_attachment: :blob).where("active_storage_blobs.content_type LIKE any ( array[?] )", types) }

      after_create_commit :eagerly_process_image_variants

      # @return [Hash] hash representing the class, used to render within the main menu
      def self.integral_backend_main_menu_item
        {
          icon: integral_icon,
          order: integral_options.dig(:backend_main_menu, :order),
          label: I18n.t('integral.navigation.storage_files'),
          url: url_helpers.send("backend_#{model_name.route_key}_url"),
          # authorize: proc { policy(self).index? }, can't use this as self is in wrong context
          authorize_class: self,
          authorize_action: :index,
          list_items: [
            { label: I18n.t('integral.navigation.dashboard'), url: url_helpers.send("backend_#{model_name.route_key}_url"), authorize_class: self, authorize_action: :index },
            { label: I18n.t('integral.actions.upload'), url: url_helpers.send("new_backend_#{model_name.singular_route_key}_url"), authorize_class: self, authorize_action: :new },
            { label: I18n.t('integral.navigation.list'), url: url_helpers.send("list_backend_#{model_name.route_key}_url"), authorize_class: self, authorize_action: :list },
          ]
        }
      end

      # @return [Hash] hash representing the class, used to render within the create menu
      def self.integral_backend_create_menu_item
        {
          icon: integral_icon,
          order: integral_options.dig(:backend_create_menu, :order),
          label: I18n.t('integral.actions.upload'),
          url: url_helpers.send("new_backend_#{model_name.singular_route_key}_url"),
          # authorize: proc { policy(self).index? }, can't use this as self is in wrong context
          authorize_class: self,
          authorize_action: :new,
        }
      end

      # @return [Hash] the instance as a list item
      def to_list_item
        {
          id: id,
          title: title,
          subtitle: attachment.byte_size,
          description: description,
          image: attachment
        }
      end

      def eagerly_process_image_variants
        if attachment.attached? && attachment.image?
          ProcessImageVariantsJob.perform_later(self)
        end
      end
    end
  end
end
