module Integral
  # User view-level logic
  class UserDecorator < BaseDecorator
    # @return [String] formatted title
    def title
      object.name
    end

    def avatar
      if object.avatar.attached?
        # TODO: Come up with a better way of linking to images/files - main_app will not be available within a host_app context
        h.main_app.url_for(object.avatar)
      else
        ActionController::Base.helpers.asset_path('integral/defaults/user_avatar.jpg')
      end
    end
  end
end
