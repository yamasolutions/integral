module Integral
  # Represents a public viewable page
  class Page < ApplicationRecord
    include LazyContentable

    acts_as_paranoid # Soft-deletion
    acts_as_integral({
      backend_main_menu: { order: 20 },
      backend_create_menu: { order: 10 }
    }) # Integral Goodness

    acts_as_listable # Listable Item

    has_paper_trail class_name: 'Integral::PageVersion'

    # Validates format of a path
    # Examples:
    # Good:
    # /foo, /foo/bar, /123/456
    # Bad:
    # //, foo, /foo bar, /foo?y=123, /foo$
    PATH_REGEX = %r{\A\/[\/.a-zA-Z0-9-]+\z|\A[\/]\z}.freeze

    enum status: %i[draft published archived]

    # Associations
    belongs_to :parent, class_name: 'Integral::Page', optional: true
    belongs_to :image, class_name: 'Integral::Image', optional: true

    has_many :resource_alternates, as: :resource
    has_many :alternates, through: :resource_alternates, source_type: "Integral::Page"

    # Validations
    validates :title, presence: true, length: { minimum: Integral.title_length_minimum,
                                                maximum: Integral.title_length_maximum }
    validates :description, presence: true, length: { minimum: Integral.description_length_minimum,
                                                      maximum: Integral.description_length_maximum }
    validates :path, presence: true, length: { maximum: 100 }
    validates :locale, presence: true
    validates :path, uniqueness: { case_sensitive: false }
    validates_format_of :path, with: PATH_REGEX
    validate :validate_path_is_not_black_listed
    validate :validate_parent_is_available

    # Nested forms
    accepts_nested_attributes_for :alternates

    # Callbacks
    before_save :set_paper_trail_event
    before_save :set_integral_notification_action
    after_initialize :set_defaults

    # Scopes
    scope :search, ->(query) { where('lower(title) LIKE ? OR lower(path) LIKE ?', "%#{query.downcase}%", "%#{query.downcase}%") }
    # TODO: Remove this on Rails 6 upgrade
    scope :not_archived, -> { where.not(status: :archived) }

    # Return all available parents
    # TODO: Update parent behaviour
    # What happens when parent is deleted or goes from published to
    # draft. Possibly allow it but show warnings on the dashboard.
    def available_parents
      if persisted?
        unavailable_ids = ancestors.map(&:id)
        unavailable_ids << id
      end

      Page.published.where.not(id: unavailable_ids).order(:title)
    end

    # @return [Hash] the instance as a list item
    def to_list_item
      {
        id: id,
        title: title,
        # subtitle: '',
        description: description,
        image: image&.url,
        url: "#{Rails.application.routes.default_url_options[:host]}#{path}"
      }
    end

    # @return [Hash] listable options to be used within a RecordSelector widget
    def self.listable_options
      {
        icon: 'file',
        record_title: I18n.t('integral.backend.record_selector.pages.record'),
        selector_path: Engine.routes.url_helpers.list_backend_pages_path,
        selector_title: I18n.t('integral.backend.record_selector.pages.title')
      }
    end

    def self.integral_icon
      'file'
    end

    # @return [Hash] the instance as a card
    def to_card
      attributes = [{ key: I18n.t('integral.records.attributes.status'), value: I18n.t("integral.records.status.#{status}") }]
      if Integral.multilingual_frontend?
        attributes += [{ key: I18n.t('integral.records.attributes.locale'), value: I18n.t("integral.language.#{locale}") }]
      end
      attributes += [
        { key: I18n.t('integral.records.attributes.path'), value: path },
        { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) }
      ]

      {
        # image: image_url,
        description: title,
        url: "#{Rails.application.routes.default_url_options[:host]}#{path}",
        attributes: attributes
      }
    end

    # @return [Array] contains available template label and key pairs
    def self.available_templates
      templates = [:default]
      templates.concat Integral.additional_page_templates

      available_templates = []
      templates.each do |template|
        available_templates << [I18n.t("integral.backend.pages.templates.#{template}"), template]
      end

      available_templates
    end

    # @return [Array] containing all page breadcrumbs within a hash made up of path and title
    def breadcrumbs
      crumb = [{
        path: path,
        title: title
      }]

      parent ? parent.breadcrumbs.concat(crumb) : crumb
    end

    # @return [Array] list of Pages which parent the instance, used for breadcrumbing
    def ancestors
      children = Page.where(parent_id: id)

      return [] if children.empty?

      descendants = children.to_a
      children.each do |page|
        descendants.concat page.ancestors
      end

      descendants
    end

    private

    def set_paper_trail_event
      if persisted? && published? && status_changed?
        self.paper_trail_event = :publish
      end
    end

    def set_integral_notification_action
      if persisted? && published? && status_changed?
        self.integral_notification_action = :publish
      end
    end

    def validate_parent_is_available
      return true if parent.nil?

      errors.add(:parent, 'Invalid Parent') unless available_parents.include?(parent)
    end

    def validate_path_is_not_black_listed
      valid = true

      Integral.black_listed_paths.each do |black_listed_path|
        next unless path&.starts_with?(black_listed_path)

        valid = false
        errors.add(:path, 'Invalid path')
        break
      end

      valid
    end

    def set_defaults
      return if self.persisted?

      self.locale ||= Integral.frontend_locales.first
    end
  end
end
