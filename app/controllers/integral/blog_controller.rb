module Integral
  # Blog controller
  class BlogController < Integral.frontend_parent_controller.constantize
    before_action :set_breadcrumbs

    private

    def set_breadcrumbs
      add_breadcrumb I18n.t('integral.breadcrumbs.home'), :root_url
    end

    def page_title
      return t('.title') unless params[:page].present?

      "Page #{params[:page]} - #{t('.title')}"
    end

    def page_description
      return t('.description') unless params[:page].present?

      "Page #{params[:page]} - #{t('.description')}"
    end
  end
end
