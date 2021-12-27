module Integral
  module Storage
    # Storage File view-level logic
    class FileDecorator < BaseDecorator
      delegate_all

      def image_url(size: nil, transform: nil, fallback: true)
        representation = if size
          attachment.representation(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[size]))
        elsif transform
          attachment.representation(transform)
        else
          attachment.representation(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[:medium]))
        end

        app_url_helpers.url_for(representation)
      end

      # @return [Hash] the instance as a card
      def to_backend_card
        attributes = [
          { key: I18n.t('integral.records.attributes.type'), value: attachment.content_type },
          { key: I18n.t('integral.records.attributes.size'), value: h.number_to_human_size(attachment.byte_size) },
          { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) },
          { key: I18n.t('integral.records.attributes.created_at'), value: I18n.l(created_at) }
        ]

        {
          image: image_url,
          description: description,
          url: backend_url,
          attributes: attributes
        }
      end
    end
  end
end
