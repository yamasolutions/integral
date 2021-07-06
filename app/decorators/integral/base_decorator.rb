module Integral
  # Base decorator for Integral view-level logic
  class BaseDecorator < Draper::Decorator
    delegate_all

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      engine_url_helpers.send("activity_backend_#{object.class.model_name.singular_route_key}_url", object.id, activity_id)
    end

    # @return [String] URL to backend Image page
    def backend_url
      engine_url_helpers.send("backend_#{object.class.model_name.singular_route_key}_url", object.id)
    end

    def to_backend_card
      attributes = [
        { key: I18n.t('integral.records.attributes.id'), value: id },
        { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) },
        { key: I18n.t('integral.records.attributes.created_at'), value: I18n.l(created_at) }
      ]

      {
        image: nil,
        description: nil,
        url: backend_url,
        attributes: attributes
      }
    end

    def render_active_block_list
      helpers.render_blocks(active_block_list.content)
    end

    private

    def image_variant_url(image, size: nil, transform: nil, fallback: true)
      image_variant = image_variant(image, size: size, transform: transform)

      if image_variant.nil?
        return fallback ? fallback_image_url : nil
      else
        app_url_helpers.url_for(image_variant)
      end
    end

    def image_variant(image, size: nil, transform: nil)
      return nil if image.nil?

      if size
        image.variant(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[size]))
      elsif transform
        image.variant(transform)
      else
        image.variant(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[:medium]))
      end
    end

    def fallback_image_url
      h.image_url('integral/defaults/no_image_available.jpg')
    end

    def engine_url_helpers
      Integral::Engine.routes.url_helpers
    end

    def app_url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
