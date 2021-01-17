module Integral
  # Front end tags controller
  class TagsController < BlogController
    before_action :find_tag, only: [:show]
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
      add_breadcrumb t('integral.breadcrumbs.tags'), :tags_url
      add_breadcrumb @tag.name, nil

      page_title = params[:page].present? ? "#{@tag.name} - Page #{params[:page]}" : @tag.name
      page_description = params[:page].present? ? "Page #{params[:page] } - #{t('integral.tags.show.description', tag_name: @tag.name)}" : t('integral.tags.show.description', tag_name: @tag.name)

      @meta_data = {
        page_title: page_title,
        page_description: page_description
      }

      @tagged_posts = Integral::Post.tagged_with(@tag.name).published.paginate(page: params[:page])
    end

    private

    def find_tag
      @tag = Integral::Post.tag_counts_on("published_#{I18n.locale}").find_by_name!(params[:id])
    end

    def set_breadcrumbs
      super
      add_breadcrumb t('integral.breadcrumbs.blog'), :posts_url
    end

    def validate_page_has_results
      if !params[:page].nil? && Integral::Post.tagged_with(@tag.name).published.paginate(page: params[:page]).empty?
        raise ActionController::RoutingError, 'Invalid Page Number'
      end
    end
  end
end
