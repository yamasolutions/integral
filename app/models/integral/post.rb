module Integral
  # Represents a user post
  class Post < ApplicationRecord
    include ActionView::Helpers::DateHelper
    include Webhook::Observable

    acts_as_paranoid # Soft-deletion
    acts_as_listable if Integral.blog_enabled? # Listable Item
    acts_as_taggable # Tagging

    has_paper_trail class_name: 'Integral::PostVersion'

    # Slugging
    extend FriendlyId
    friendly_id :title, use: :history

    enum status: %i[draft published]

    # Conditional hack to check if method exists otherwise causes undefined method error in test env
    self.per_page = 8 if respond_to? :per_page

    # Associations
    belongs_to :user
    belongs_to :image, class_name: 'Integral::Image', optional: true
    belongs_to :preview_image, class_name: 'Integral::Image', optional: true

    # Validations
    validates :title, presence: true, length: { minimum: 4, maximum: 60 }
    validates :description, presence: true, length: { minimum: 50, maximum: 300 }
    validates :body, :user, :slug, presence: true

    # Callbacks
    before_save :set_published_at
    before_save :set_tags_context
    after_update :deliver_published_webhook_on_update
    after_create :deliver_published_webhook_on_create

    # Aliases
    alias author user
    alias featured_image image

    # Scopes
    scope :search, ->(query) { where('lower(title) LIKE ? OR lower(slug) LIKE ?', "%#{query.downcase}%", "%#{query.downcase}%") }

    # @return [Array] containing available human readable statuses against there numeric value
    def self.available_statuses(opts = { reverse: false })
      statuses = [
        [I18n.t('integral.records.status.draft'), 0],
        [I18n.t('integral.records.status.published'), 1]
      ]

      opts[:reverse] ? statuses.each(&:reverse!) : statuses
    end

    # Increments the view count of the post if a PostViewing is successfully added
    #
    # @param ip_address [String] Viewers IP address
    def increment_count!(ip_address)
      increment!(:view_count) if PostViewing.add(self, ip_address)
    end

    # @return [Hash] the instance as a list item
    def to_list_item
      subtitle = published_at.present? ? I18n.t('integral.blog.posted_ago', time: time_ago_in_words(published_at)) : I18n.t('integral.users.status.draft')
      {
        id: id,
        title: title,
        subtitle: subtitle,
        description: description,
        image: featured_image,
        url: Integral::Engine.routes.url_helpers.post_url(self)
      }
    end

    # @return [Hash] the instance as a card
    def to_card
      image_url = featured_image.file.url if featured_image
      {
        image: image_url,
        description: title,
        url: url,
        attributes: [
          { key: I18n.t('integral.records.attributes.author'), value: author.name },
          { key: I18n.t('integral.records.attributes.views'), value: view_count },
          { key: I18n.t('integral.records.attributes.status'), value: I18n.t("integral.records.status.#{status}") },
          { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) }
        ]
      }
    end

    # @return [String] URL to frontend route
    def url
      Integral::Engine.routes.url_helpers.post_url(self)
    end

    # @return [Hash] listable options to be used within a RecordSelector widget
    def self.listable_options
      {
        icon: 'rss',
        record_title: I18n.t('integral.backend.record_selector.posts.record'),
        selector_path: Engine.routes.url_helpers.backend_posts_path,
        selector_title: I18n.t('integral.backend.record_selector.posts.title')
      }
    end

    # @return [String] Current tag context
    def tag_context
      status
    end

    # @return [Array] ActsAsTaggableOn::Tag tags associated with this post
    def tags
      tags_on(tag_context)
    end

    private

    def webhook_payload
      Integral::PostSerializer.new(self).serializable_hash
    end

    def set_slug
      if slug_changed? && Post.exists_by_friendly_id?(slug)
        self.slug = resolve_friendly_id_conflict([slug])
      end
    end

    def set_published_at
      self.published_at = Time.now if published? && published_at.nil?
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
        contexts << status
      end
      contexts.delete(tag_context)
      contexts
    end

    def deliver_published_webhook_on_update
      deliver_webhook(:published) if self.status_changed? && self.published?
    end

    def deliver_published_webhook_on_create
      deliver_webhook(:published) if self.published?
    end
  end
end
