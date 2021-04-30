module Integral
  # User view-level logic
  class UserDecorator < BaseDecorator
    # @return [String] formatted title
    def title
      object.name
    end

    def image_url(size: :small, transform: nil)
      image_variant_url(image, size: size, transform: transform)
    end

    def avatar_url(size: :thumbnail, transform: nil)
      image_url(size: size, transform: transform)
    end

    def fallback_image_url
      h.image_url('integral/defaults/user_avatar.jpg')
    end
  end
end
