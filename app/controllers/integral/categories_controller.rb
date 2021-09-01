module Integral
  # Front end categories controller
  class CategoriesController < BlogController
    before_action :validate_routed_through_alias, only: [:show]
    before_action :set_resource, only: [:show]
    before_action :set_collection, only: [:show]
    before_action :validate_page_has_results, only: [:show]

    # GET /:id
    # Presents all posts with particular category
    def show
      add_breadcrumb @resource.title, nil

      @meta_data = {
        page_title: append_page(@resource.title),
        page_description: append_page(@resource.description),
        image: @resource.image_url(size: :large)
      }
    end

    def url_for(options={})
      if options.is_a?(Hash) && options.include?(:category_path) && options[:category_path] == true
        "#{category_path(@resource)}?page=#{options[:page]}"
      elsif options.is_a?(Hash) && options.empty?
        category_path(@resource)
      else
        super(options)
      end
    end
    helper_method :url_for

    private

    def canonical_url
      url = if Integral.multilingual_frontend?
              "#{Rails.application.routes.default_url_options[:host]}/#{I18n.locale}/#{Integral.blog_namespace}/#{@resource.slug}"
            else
              "#{Rails.application.routes.default_url_options[:host]}/#{Integral.blog_namespace}/#{@resource.slug}"
            end
      url += "?page=#{params[:page]}" if params[:page].present?
      url
    end

    def set_resource
      @resource = Integral::Category.where(locale: I18n.locale).find(params[:id]).decorate
    end

    def set_collection
      @posts = Integral::Post.published.where(category_id: @resource.id).includes(:image).order('published_at DESC').paginate(page: params[:page]).decorate
    end

    def set_breadcrumbs
      super
      add_breadcrumb t('integral.breadcrumbs.blog'), integral.posts_url
    end

    def validate_page_has_results
      raise_pagination_out_of_range if @posts.empty?
    end
  end
end
