module Integral
  # Blog controller
  class BlogController < Integral.frontend_parent_controller.constantize
    before_action :set_side_bar_data
    before_action :set_breadcrumbs

    private

    def set_side_bar_data
      load_recent_posts
      load_popular_posts
      load_blog_tags
    end

    def set_breadcrumbs
      add_breadcrumb I18n.t('integral.breadcrumbs.home'), :root_url
    end
  end
end
