module Integral
  # Category view-level logic
  class CategoryDecorator < Draper::Decorator
    delegate_all

    def posts(limit=nil)
      object.posts.published.order('published_at DESC').limit(limit).decorate
    end

    def image_url
      if object.image.present?
        object.image.url
      else
        helpers.image_url('integral/image-not-set.png')
      end
    end
  end
end
