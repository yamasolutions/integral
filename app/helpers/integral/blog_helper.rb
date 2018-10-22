module Integral
  # Blog Helper which contains methods used through the blog
  module BlogHelper
    # Whether or not to display newsletter signup widget
    def display_newsletter_signup_widget?
      true
    end

    # Whether or not to display share widget
    def display_share_widget?
      return true if "#{controller_name}.#{action_name}" == 'posts.show'
      false
    end

    # Whether or not to display recent posts sidebar widget
    def display_recent_posts_widget?
      return false if "#{controller_name}.#{action_name}" == 'posts.index'
      true
    end

    # Whether or not to display recent posts sidebar widget
    def display_popular_posts_widget?
      Integral::Post.published.count > 4
    end
  end
end
