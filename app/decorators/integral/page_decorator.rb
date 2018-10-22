module Integral
  # Page view-level logic
  class PageDecorator < Draper::Decorator
    delegate_all

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      Integral::Engine.routes.url_helpers.activity_backend_page_url(object.id, activity_id)
    end

    # @return [String] URL to backend list page
    def url
      Integral::Engine.routes.url_helpers.edit_backend_page_url(self)
    end

    # @return [String] formatted title
    def title
      object.title
    end

    # @return [String] formatted body
    def body
      object.body.html_safe
    end
  end
end
