module Integral
  # Page view-level logic
  class PostDecorator < BaseDecorator
    decorates_association :category
    decorates_association :user

    # @return [Hash] the instance as a card
    def to_backend_card
      image_url = object.image&.attached? ? app_url_helpers.url_for(image.attachment) : nil
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
          preview_image_url(size: :large),
          image_url(size: :large)
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
      h.image_tag user.avatar_url, class: 'user-avatar', alt: user.name if user.present?
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

    def preview_image_url(size: nil, transform: nil)
      return image_url(size: size, transform: transform) if preview_image.nil?

      image_variant_url(preview_image, size: size, transform: transform)
    end

    def image_url(size: nil, transform: nil)
      image_variant_url(image, size: size, transform: transform)
    end

    # Date the post was published
    def published_at
      return I18n.l(object.published_at, format: :blog) if object.published?

      'Not yet published'
    end

    # @return [String] URL to backend post page
    def backend_url
      if Integral.blog_enabled?
        engine_url_helpers.backend_post_url(object.id)
      else
        ''
      end
    end

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      if Integral.blog_enabled?
        engine_url_helpers.activity_backend_post_url(object.id, activity_id)
      else
        ''
      end
    end
  end
end
