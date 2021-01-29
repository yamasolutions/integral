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

    private

    def image_variant(image, size: nil, transform: nil)
      if size
        image.variant(resize_to_limit: Integral.image_sizes[size])
      elsif transform
        image.variant(transform)
      else
        image.variant(resize_to_limit: Integral.image_sizes[:medium])
      end
    end

    def engine_url_helpers
      Integral::Engine.routes.url_helpers
    end

    def app_url_helpers
      Rails.application.routes.url_helpers
    end

    def render_active_block_list
      helpers.render_blocks(active_block_list.content)
    end
  end
end
