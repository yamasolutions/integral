module Integral
  # Base decorator for Integral view-level logic
  class BaseDecorator < Draper::Decorator
    delegate_all

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      Integral::Engine.routes.url_helpers.send("activity_backend_#{object.class.model_name.singular_route_key}_url", object.id, activity_id)
    end

    # @return [String] URL to backend Image page
    def backend_url
      Integral::Engine.routes.url_helpers.send("backend_#{object.class.model_name.singular_route_key}_url", object.id)
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
  end
end
