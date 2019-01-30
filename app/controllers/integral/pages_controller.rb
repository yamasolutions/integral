module Integral
  # Renders dynamic pages
  class PagesController < Integral.frontend_parent_controller.constantize
    before_action :find_page, only: [:show]
    before_action :set_breadcrumbs

    # GET /{page.path}
    # Presents dynamic pages
    def show
      @meta_data = {
        page_title: @page.title,
        page_description: @page.description,
        open_graph:  {
          image: @page.image&.url(:large)
        }
      }

      render "integral/pages/templates/#{@page.template}"
    end

    private

    def find_page
      scope = if current_user.present?
                Integral::Page
              else
                Integral::Page.published
              end

      @page = scope.find(params[:id]).decorate
    end

    def set_breadcrumbs
      add_breadcrumb I18n.t('header.navigation.home'), :root_url

      @page.breadcrumbs.each do |breadcrumb|
        add_breadcrumb breadcrumb[:title], "#{Rails.application.routes.default_url_options[:host]}#{breadcrumb[:path]}"
      end
    end

    def canonical_url
      if Settings[:homepage_id]&.to_i == @page.id
        Rails.application.routes.default_url_options[:host].to_s
      else
        "#{Rails.application.routes.default_url_options[:host]}#{@page.path}"
      end
    end
  end
end
