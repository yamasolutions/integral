module Integral
  # Base Frontend controller
  class ApplicationController < ActionController::Base
    include Pundit
    protect_from_forgery with: :exception

    layout 'integral/frontend'

    # TODO: Upgrade BeforeRender (currently does not supper Rails 5)
    # Commented until before_render is Rails 5 compatible, currently using :render override
    # Search Engine Optimization
    # before_render :load_meta_tags

    # Override added as workaround for before_render Rails 5 incompatibility
    def render(*args, &block)
      before_render
      super
    end

    helper_method :category_path
    def category_path(category)
      "/#{Integral.blog_namespace}/#{category.slug}"
    end

    private

    # Actions that should be carried out before rendering
    def before_render
      load_meta_tags
    end

    def load_meta_tags
      meta_data = set_meta_data

      meta_options = {
        site: meta_data[:site_title],
        title: meta_data[:page_title],
        reverse: root_path != request.path,
        description: meta_data[:page_description],
        icon: '/favicon.ico',
        alternate: meta_data[:alternative],
        canonical: meta_data[:canonical],
        og: meta_data[:open_graph],
        twitter: meta_data[:twitter_card],
        fb: meta_data[:facebook]
      }

      set_meta_tags meta_options
      set_meta_tags og: { title: meta_tags.full_title }
    end

    def set_meta_data
      meta_data = @meta_data.blank? ? {} : @meta_data
      meta_data[:open_graph] = {} if meta_data[:open_graph].blank?
      meta_data[:site_title] ||= Settings.website_title
      meta_data[:page_title] ||= t('.title')
      meta_data[:page_description] ||= t('.description')
      meta_data[:canonical] ||= canonical_url
      meta_data[:alternative] ||= alternative_urls

      open_graph_defaults = {
        title: meta_data[:page_title],
        description: meta_data[:page_description],
        image: default_preview_image,
        type: 'website',
        site_name: meta_data[:site_title],
        url: meta_data[:canonical]
      }

      meta_data[:open_graph].reject! { |_k, v| v.nil? }
      meta_data[:open_graph] = open_graph_defaults.merge!(meta_data[:open_graph])

      meta_data[:twitter_card] = {
        card: 'summary_large_image',
        site: Settings.twitter_handler,
        title: meta_data[:open_graph][:title],
        description: meta_data[:open_graph][:description],
        image: meta_data[:open_graph][:image]
      }

      meta_data[:facebook] = {
        app_id: Settings.facebook_app_id
      }

      meta_data
    end

    # @return [String] URL to the default preview image (if one exists)
    def default_preview_image
      return unless Settings.default_preview_image_path

      view_context.image_url(Settings.default_preview_image_path)
    end

    # @return [String] Canonical URL
    def canonical_url
      url = "#{Rails.application.routes.default_url_options[:host]}#{request.path}"
      url += "?page=#{params[:page]}" if params[:page].present?
      url
    end
    helper_method :canonical_url

    # Alternative URLs for a particular page to be consumed by different regions/counties.
    # Only required for multi-lingual websites.
    #
    # @return [Hash] all available URLs for different countries/regions for the same content
    #
    # example return:
    # {
    #   "fr" => "http://yoursite.fr/alternate/url",
    #   "de" => "http://yoursite.de/alternate/url"
    # }
    #
    def alternative_urls
      {}
    end

    def load_blog_tags
      @blog_tags = Integral::Post.tag_counts_on('published', order: 'taggings_count desc', limit: 30)
    end

    def load_recent_posts
      @recent_posts = Integral::Post.published.order('published_at DESC').limit(4)
    end

    def load_popular_posts
      @popular_posts = Integral::Post.published.order('view_count DESC').limit(4)
    end

    # Raises 404 if no user is logged in
    def verify_user
      raise ActionController::RoutingError, 'Not Found' if current_user.blank?
    end
  end
end
