module Integral
  # Represents a user post
  class Post < ApplicationRecord
    include ActionView::Helpers::DateHelper
    include LazyContentable
    include Webhook::Observable

    acts_as_integral({
      icon: 'rss',
      listable: { enabled: Integral.blog_enabled? },
      backend_main_menu: { order: 30, enabled: Integral.blog_enabled? },
      backend_create_menu: { order: 20, enabled: Integral.blog_enabled? }
    }) # Integral Goodness
    acts_as_paranoid # Soft-deletion
    acts_as_taggable # Tagging

    has_paper_trail versions: { class_name: 'Integral::PostVersion' }

    # Slugging
    extend FriendlyId
    friendly_id :title, use: :history

    enum status: %i[draft published]

    # Conditional hack to check if method exists otherwise causes undefined method error in test env
    self.per_page = 8 if respond_to? :per_page

    # Associations
    belongs_to :user, -> { with_deleted }
    belongs_to :category
    belongs_to :image, class_name: 'Integral::Storage::File', optional: true
    belongs_to :preview_image, class_name: 'Integral::Storage::File', optional: true

    has_many :resource_alternates, as: :resource
    has_many :alternates, through: :resource_alternates, source_type: "Integral::Post"

    # Validations
    validates :title, presence: true, length: { minimum: Integral.title_length_minimum,
                                                maximum: Integral.title_length_maximum }
    validates :description, presence: true, length: { minimum: Integral.description_length_minimum,
                                                      maximum: Integral.description_length_maximum }
    validates :body, :user, :slug, presence: true
    validates :locale, presence: true

    # Nested forms
    accepts_nested_attributes_for :alternates

    # Callbacks
    after_initialize :set_defaults
    before_save :set_published_at
    before_save :set_paper_trail_event
    before_save :set_tags_context
    after_update :deliver_published_webhook_on_update
    after_create :deliver_published_webhook_on_create

    # Aliases
    alias author user
    alias featured_image image

    # Scopes
    scope :search, ->(query) { where('lower(title) LIKE ? OR lower(slug) LIKE ?', "%#{query.downcase}%", "%#{query.downcase}%") }

    # Increments the view count of the post if a PostViewing is successfully added
    #
    # @param ip_address [String] Viewers IP address
    def increment_count!(ip_address)
      increment!(:view_count) if PostViewing.add(self, ip_address)
    end

    # @return [Hash] the instance as a list item
    def to_list_item
      subtitle = published_at.present? ? I18n.t('integral.blog.posted_ago', time: time_ago_in_words(published_at)) : I18n.t('integral.statuses.draft')
      {
        id: id,
        title: title,
        subtitle: subtitle,
        description: description,
        image: featured_image&.attachment,
        url: frontend_url
      }
    end

    def frontend_url
      route = Integral.multilingual_frontend? ? "post_#{locale}_url" : 'page_url'
      Integral::Engine.routes.url_helpers.send(route, slug)
    end

    # @return [String] Current tag context
    def tag_context
      "#{status}_#{locale}"
    end

    # @return [Array] ActsAsTaggableOn::Tag tags associated with this post
    def tags
      tags_on(tag_context)
    end

    def to_param
      id
    end

    private

    def webhook_payload
      Integral::PostSerializer.new(self).serializable_hash
    end

    def set_slug
      if slug_changed? && Post.where(locale: locale).exists_by_friendly_id?(slug)
        self.slug = resolve_friendly_id_conflict([slug])
      end
    end

    def set_published_at
      if published? && published_at.nil?
        self.published_at = Time.now
      end
    end

    def set_paper_trail_event
      if persisted? && published? && status_changed?
        self.paper_trail_event = :publish
      end
    end

    # Set the context of tags so that draft and archived tags are not displayed publicly
    def set_tags_context
      return unless tag_list_changed? || status_changed? || !persisted?

      # Give all tags current context
      set_tag_list_on(tag_context, tag_list)

      # Clear previous contexts
      self.tag_list = []
      inactive_tag_contexts.each do |context|
        set_tag_list_on(context, [])
      end
    end

    # @return [Array] containing all inactive tag contexts
    def inactive_tag_contexts
      contexts = []

      self.class.statuses.each_key do |status|
        Integral.frontend_locales.each do |locale|
          contexts << "#{status}_#{locale}"
        end
      end
      contexts.delete(tag_context)
      contexts
    end

    def deliver_published_webhook_on_update
      deliver_webhook(:published) if saved_change_to_status? && published?
    end

    def deliver_published_webhook_on_create
      deliver_webhook(:published) if published?
    end

    def set_defaults
      return if self.persisted?

      self.locale ||= Integral.frontend_locales.first
    end
  end
end
