module Integral
  # Front end categories controller
  class CategoriesController < BlogController
    before_action :find_resource, only: [:show]

    # GET /:id
    # Presents all posts with particular category
    def show
      add_breadcrumb @resource.title, nil

      page_title = params[:page].present? ? "#{@resource.title} - Page #{params[:page]}" : @resource.title
      page_description = params[:page].present? ? "#{@resource.description} - Page #{params[:page]}" : @resource.description

      @meta_data = {
        page_title: page_title,
        page_description: page_description,
        image: @resource&.image&.url
      }

      @posts = Integral::Post.published.where(category_id: @resource.id).paginate(page: params[:page])
    end

    private

    def find_resource
      @resource = Integral::Category.find(params[:id])
    end

    def set_breadcrumbs
      super
      add_breadcrumb t('integral.breadcrumbs.blog'), :posts_url
    end
  end
end
