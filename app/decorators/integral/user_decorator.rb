module Integral
  # User view-level logic
  class UserDecorator < Draper::Decorator
    delegate_all

    def avatar_url(dimensions='100x100')
      if object.avatar.attached?
        helpers.rails_representation_url(object.avatar.variant(resize: dimensions).processed)
      else
        helpers.image_url('integral/defaults/user_avatar.jpg')
      end
    end

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      # Integral::Engine.routes.url_helpers.activity_backend_user_url(object.id, activity_id)
    end

    # @return [String] URL to backend list page
    def backend_url
      Integral::Engine.routes.url_helpers.backend_user_url(self)
    end

    # @return [String] formatted title
    def title
      object.name
    end
  end
end
