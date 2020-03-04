module Integral
  # Image view-level logic
  class ImageDecorator < Draper::Decorator
    delegate_all

    def url(dimensions='100x100')
      if object.file.attached?
        helpers.rails_representation_url(file.variant(resize: dimensions).processed)
      else
        nil
      end
    end

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      # Integral::Engine.routes.url_helpers.activity_backend_img_url(object.id, activity_id)
    end

    # @return [String] URL to backend Image page
    def backend_url
      Integral::Engine.routes.url_helpers.edit_backend_img_url(object)
    end
  end
end
