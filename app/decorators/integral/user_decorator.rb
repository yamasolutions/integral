module Integral
  # User view-level logic
  class UserDecorator < Draper::Decorator
    delegate_all

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      Integral::Engine.routes.url_helpers.activity_backend_user_url(object.id, activity_id)
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
