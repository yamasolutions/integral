module Integral
  # Category view-level logic
  class CategoryDecorator < BaseDecorator
    delegate_all

    # @return [String] URL to backend activity
    def activity_url(activity_id)
      Integral::Engine.routes.url_helpers.activity_backend_category_url(object.id, activity_id)
    end

    # @return [String] URL to backend Image page
    def backend_url
      Integral::Engine.routes.url_helpers.backend_posts_url
    end

    # @return [Relation] posts associated to the category
    def posts(limit = nil)
      object.posts.published.order('published_at DESC').limit(limit).decorate
    end

    # @return [String] image URL associated to the category
    def image_url
      if object.image.present?
        object.image.url
      else
        helpers.image_url('integral/image-not-set.png')
      end
    end
  end
end
