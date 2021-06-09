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

    def image_url(size: nil, transform: nil, fallback: true)
      image_variant_url(image, size: size, transform: transform, fallback: fallback)
    end
  end
end
