module Integral
  module Storage
    # Storage File view-level logic
    class FileDecorator < BaseDecorator
      delegate_all

      # @return [Hash] the instance as a card
      def to_backend_card
        attributes = [
          { key: I18n.t('integral.records.attributes.type'), value: attachment.content_type },
          { key: I18n.t('integral.records.attributes.size'), value: h.number_to_human_size(attachment.byte_size) },
          { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) },
          { key: I18n.t('integral.records.attributes.created_at'), value: I18n.l(created_at) }
        ]

        {
          image: app_url_helpers.url_for(attachment.representation(resize_to_limit: [500, 500])),
          description: description,
          url: backend_url,
          attributes: attributes
        }
      end
    end
  end
end
