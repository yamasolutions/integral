module Integral
  # Page view-level logic
  class PostDecorator < BaseDecorator
    decorates_association :category

    # @return [Hash] the instance as a card
    def to_backend_card
      image_url = object.image&.attached? ? h.main_app.url_for(image.attachment) : nil
      attributes = [{ key: I18n.t('integral.records.attributes.status'), value: I18n.t("integral.records.status.#{status}") }]
      if Integral.multilingual_frontend?
        attributes += [{ key: I18n.t('integral.records.attributes.locale'), value: I18n.t("integral.language.#{locale}") }]
      end
      attributes += [
        { key: I18n.t('integral.records.attributes.slug'), value: slug },
        { key: I18n.t('integral.records.attributes.author'), value: author.name },
        { key: I18n.t('integral.records.attributes.views'), value: view_count },
        { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) },
        { key: I18n.t('integral.records.attributes.created_at'), value: I18n.l(created_at) }
      ]

      {
        image: image_url,
        description: title,
        url: backend_url,
        attributes: attributes
      }
    end

    # Enables pagination
    def self.collection_decorator_class
      PaginatingDecorator
    end

    # @return [Hash] JSON-LD representing the instance
    def to_json_ld
      {
        "@type": 'blogPosting',
        "mainEntityOfPage": object.frontend_url,
        "headline": title,
        "description": description,
        "datePublished": object.published_at,
        "dateModified": object.updated_at,
        "author": {
          "@type": 'Person',
          "name": object.author&.name
        },
        "image": [
          preview_image(:large),
          image(:large)
        ],
        "publisher": {
          "@type": 'Organization',
          "name": Integral::Settings.website_title,
          "logo": {
            "@type": 'ImageObject',
            "url": h.image_url('logo.png')
          }
        }
      }
    end

    # @return [String] avatar image
    def avatar
      avatar_url = user&.avatar&.url(:thumbnail)
      h.image_tag avatar_url, class: 'user-avatar' unless avatar_url.nil?
    end

    # Tags to be used within the header of an article to describe the subject
    def header_tags
      return I18n.t('integral.posts.show.subtitle') if object.tags_on(object.tag_context).empty?

      header_tags = ''
      object.tags_on(object.tag_context).each_with_index do |tag, i|
        header_tags += tag.name
        header_tags += ' | ' unless i == object.tags_on(object.tag_context).size - 1
      end
      header_tags
    end

    # Preview image for the post if present. Otherwise returns featured image
    def preview_image(size = :small)
      preview_image = object&.preview_image&.url(size)
      return preview_image if preview_image.present?

      image(size, false)
    end

    # Image for the post if present. Otherwise returns default image
    def image(size = :small, fallback = true)
      image = object&.image&.url(size)
      return image if image.present?

      h.image_url('integral/defaults/no_image_available.jpg') if fallback
    end

    # Date the post was published
    def published_at
      return I18n.l(object.published_at, format: :blog) if object.published?

      'Not yet published'
    end

    # @return [String] URL to backend post page
    def backend_url
      if Integral.blog_enabled?
        Integral::Engine.routes.url_helpers.backend_post_url(object.id)
      else
        ''
      end
    end

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      if Integral.blog_enabled?
        Integral::Engine.routes.url_helpers.activity_backend_post_url(object.id, activity_id)
      else
        ''
      end
    end

    # @return [String] formatted body
    def body
      object.body&.html_safe
    end
  end
end
