module Integral
  # Page view-level logic
  class PageDecorator < BaseDecorator
    # @return [Hash] the instance as a backend card
    def to_backend_card
      attributes = [{ key: I18n.t('integral.records.attributes.status'), value: I18n.t("integral.records.status.#{status}") }]
      if Integral.multilingual_frontend?
        attributes += [{ key: I18n.t('integral.records.attributes.locale'), value: I18n.t("integral.language.#{locale}") }]
      end
      attributes += [
        { key: I18n.t('integral.records.attributes.path'), value: path },
        { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) },
        { key: I18n.t('integral.records.attributes.created_at'), value: I18n.l(created_at) }
      ]

      image_url = object.image&.attached? ? app_url_helpers.url_for(image.attachment) : nil

      {
        image: image_url,
        description: title,
        url: backend_url,
        attributes: attributes
      }
    end

    def image_url(size: nil, transform: nil)
      image_variant_url(image, size: size, transform: transform)
    end
  end
end
