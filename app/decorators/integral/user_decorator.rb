module Integral
  # User view-level logic
  class UserDecorator < BaseDecorator
    # @return [String] formatted title
    def title
      object.name
    end

    def avatar_url
      if object.avatar.attached?
        app_url_helpers.url_for(object.avatar)
      else
        ActionController::Base.helpers.asset_path('integral/defaults/user_avatar.jpg')
      end
    end

    def avatar_circle
      if object.avatar.attached?
        h.image_tag(avatar_url)
      else
        initials = object.name.split(' ').map { |name| name[0] }.join[0..1]
        avatar_color = Integral.avatar_colors[initials.first.to_s.downcase.ord % 10]

        style = "background-color: #{avatar_color};"
        h.content_tag :div, class: 'avatar-circle', style: style do
          h.content_tag :div, initials, class: 'avatar-text'
        end
      end
    end
  end
end


