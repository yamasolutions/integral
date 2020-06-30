module Integral
  # Image view-level logic
  class ImageDecorator < Draper::Decorator
    delegate_all

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      Integral::Engine.routes.url_helpers.activity_backend_img_url(object.id, activity_id)
    end

    # @return [String] URL to backend Image page
    def backend_url
      Integral::Engine.routes.url_helpers.backend_img_url(object)
    end
  end
end
