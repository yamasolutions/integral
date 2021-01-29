module Integral
  # Renders dynamic pages
  class PagesController < Integral.frontend_parent_controller.constantize
    before_action :validate_routed_through_alias, only: [:show]
    before_action :find_page, only: [:show]
    before_action :set_breadcrumbs

    # GET /{page.path}
    # Presents dynamic pages
    def show
      @meta_data = {
        page_title: @page.title,
        page_description: @page.description,
        open_graph: {
          image: @page.image_url(size: :large)
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
      breadcrumbs = @page.breadcrumbs
      breadcrumbs.pop

      breadcrumbs.each do |breadcrumb|
        # Override the homepage title so that it's a simple breadcrumb instead of the SEO (<title>) version
        title = if Integral.frontend_locales.map { |locale| "/#{locale}" }.include?(breadcrumb[:path]) || breadcrumb[:path] == '/'
          I18n.t('integral.navigation.home')
        else
          breadcrumb[:title]
        end
        add_breadcrumb title, "#{Rails.application.routes.default_url_options[:host]}#{breadcrumb[:path]}"
      end

      add_breadcrumb @page.title
    end

    def canonical_url
      "#{Rails.application.routes.default_url_options[:host]}#{@page.path}"
    end

    def alternative_urls
      alternative_urls = {
        I18n.locale.to_s => canonical_url
      }

      @page.alternates.published.each do |alternate|
        alternative_urls[alternate.locale] = "#{Rails.application.routes.default_url_options[:host]}#{alternate.path}"
      end

      alternative_urls
    end
  end
end
