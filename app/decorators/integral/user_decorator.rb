module Integral
  # User view-level logic
  class UserDecorator < BaseDecorator
    # @return [String] formatted title
    def title
      object.name
    end

    def avatar_url
      if object.avatar.attached?
        h.main_app.url_for(object.avatar)
      else
        ActionController::Base.helpers.asset_path('integral/defaults/user_avatar.jpg')
      end
    end
  end
end
