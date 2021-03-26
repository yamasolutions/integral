module Integral
  # Posts controller
  class PostsController < BlogController
    before_action :find_post, only: [:show]
    before_action :find_related_posts, only: [:show]
    before_action :validate_page_has_results, only: [:index]
    after_action :increment_post_count, only: [:show]

    # GET /
    # List blog posts
    def index
      add_breadcrumb I18n.t('integral.breadcrumbs.blog'), nil

      @latest_post = Integral::Post.published.where(locale: I18n.locale).order('published_at DESC').first&.decorate
      @posts = Integral::Post.published.where(locale: I18n.locale).includes(:image, :user).order('published_at DESC').paginate(page: params[:page])
      @posts = @posts.where.not(id: @latest_post.id) if @latest_post

      page_title = t('integral.posts.index.title')
      page_description = t('integral.posts.index.description')
      if params[:page].present?
        page_title += " - Page #{params[:page]}"
        page_description += " - Page #{params[:page]}"
      end

      @meta_data = {
        page_title: page_title,
        page_description: page_description
      }
    end

    # GET /<post.slug>
    # Presents blog postings
    def show
      add_breadcrumb I18n.t('integral.breadcrumbs.blog'), integral.posts_url
      add_breadcrumb @post.title, nil

      @meta_data = {
        page_title: @post.title,
        page_description: @post.description,
        open_graph: {
          image: @post.preview_image_url(size: :large)
        }
      }
      template = 'default' # TODO: Implement post templates
      render "integral/posts/templates/#{template}"
    end

    private

    def alternative_urls
      alternative_urls = {
        I18n.locale.to_s => canonical_url
      }

      if action_name == 'show'
        @post.alternates.published.each do |alternate|
          alternative_urls[alternate.locale] = alternate.frontend_url
        end
      elsif
        Integral.frontend_locales.reject{ |l| l == I18n.locale}.each do |locale|
          alternative_urls[locale.to_s] = integral.send("posts_#{locale}_url")
        end
      end
      alternative_urls
    end

    def increment_post_count
      @post.increment_count!(request.ip)
    end

    # Creates array of related posts. If enough related posts do not exist uses popular posts
    def find_related_posts
      @related_posts = @post.find_related_tags.limit(amount_of_related_posts_to_display)
      amount_of_related_posts = @related_posts.length

      if amount_of_related_posts != amount_of_related_posts_to_display && (amount_of_related_posts + @popular_posts.length) >= amount_of_related_posts_to_display
        @related_posts = @related_posts.to_a.concat(@popular_posts[0...amount_of_related_posts_to_display - amount_of_related_posts])
      end
    end

    def amount_of_related_posts_to_display
      3
    end

    def find_post
      @post = if current_user.present?
                Integral::Post.where(locale: I18n.locale).friendly.find(params[:id]).decorate
              else
                Integral::Post.where(locale: I18n.locale).friendly.published.find(params[:id]).decorate
              end

      @post.decorate

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      redirect_to integral.post_url(@post.slug), status: :moved_permanently if request.path != integral.post_path(@post.slug)
    end

    def validate_page_has_results
      if !params[:page].nil? && Integral::Post.published.where(locale: I18n.locale).paginate(page: params[:page]).empty?
        raise_pagination_out_of_range
      end
    end
  end
end
