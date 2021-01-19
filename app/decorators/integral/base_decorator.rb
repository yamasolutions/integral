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

    def render_active_block_list
      helpers.render_blocks(active_block_list.content)
    end
  end
end
