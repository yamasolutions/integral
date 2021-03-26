module Integral
  # Front end tags controller
  class TagsController < BlogController
    before_action :set_resource, only: [:show]
    before_action :set_collection, only: [:show]
    before_action :validate_page_has_results, only: [:show]

    # GET /
    # List blog tags
    def index
      add_breadcrumb t('integral.breadcrumbs.tags'), nil
      @tags = Integral::Post.tag_counts_on("published_#{I18n.locale}", order: 'taggings_count desc').paginate(page: params[:page])
    end

    # GET /:id
    # Presents blog tags
    def show
      add_breadcrumb t('integral.breadcrumbs.tags'), integral.tags_url
      add_breadcrumb @tag.name, nil

      page_title = "Posts tagged with #{@tag.name}"
      page_title += " - Page #{params[:page]}" if params[:page].present?
      page_description = params[:page].present? ? "Page #{params[:page] } - #{t('integral.tags.show.description', tag_name: @tag.name)}" : t('integral.tags.show.description', tag_name: @tag.name)

      @meta_data = {
        page_title: page_title,
        page_description: page_description
      }
    end

    private

    def set_resource
      @tag = Integral::Post.tag_counts_on("published_#{I18n.locale}").find_by_name!(params[:id])
    end

    def set_collection
      @tagged_posts = PostDecorator.decorate_collection(Integral::Post.tagged_with(@tag.name).where(locale: I18n.locale).published.distinct.order("published_at DESC").paginate(:page => params[:page]))
    end

    def set_breadcrumbs
      super
      add_breadcrumb t('integral.breadcrumbs.blog'), integral.posts_url
    end

    def validate_page_has_results
      raise_pagination_out_of_range if @tagged_posts.empty? && params[:page].present?
    end
  end
end
