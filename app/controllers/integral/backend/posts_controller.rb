module Integral
  module Backend
    # Post management
    class PostsController < BaseController
      before_action :set_post, only: %i[edit update destroy show activities activity]

      # GET /
      # Lists all posts
      def index
        respond_to do |format|
          format.html do
            set_grid(Integral::Grids::PostsGrid)
          end

          format.json do
            if params[:gridview].present?
              set_grid(Integral::Grids::PostsGrid)
              render json: { content: render_to_string(partial: 'integral/backend/posts/grid', locals: { grid: @grid }) }
            else
              respond_to_record_selector(Integral::Post)
            end
          end
        end
      end

      # GET /new
      # Post creation form
      def new
        add_breadcrumb I18n.t('integral.navigation.new'), :new_backend_post_path
        @post = Post.new
      end

      # POST /
      # Post creation
      def create
        @post = Post.new(post_params)
        @post.user = current_user

        if @post.save
          respond_successfully(notification_message('creation_success'), edit_backend_post_path(@post.id))
        else
          respond_failure(notification_message('creation_failure'), @post, :new)
        end
      end

      # GET /:id/edit
      # Post edit form
      def edit
        add_breadcrumb I18n.t('integral.navigation.edit'), :edit_backend_post_path
      end

      # PUT /:id
      # Updating a post
      def update
        if @post.update(post_params)
          respond_successfully(notification_message('edit_success'), edit_backend_post_path(@post.id))
        else
          respond_failure(notification_message('edit_failure'), @post, :edit)
        end
      end

      # DELETE /:id
      def destroy
        if @post.destroy
          respond_successfully(notification_message('delete_success'), backend_posts_path)
        else
          flash[:error] = notification_message('delete_failure')
          redirect_to backend_posts_path
        end
      end

      # GET /:id/activities
      def activities
        respond_with_activities(:edit_backend_post_url)
      end

      # GET /:id/activities/:id
      def activity
        authorize Version

        add_breadcrumb I18n.t('integral.navigation.activity'), :activities_backend_post_url
        add_breadcrumb I18n.t('integral.actions.view')

        @activity = PostVersion.find(params[:activity_id]).decorate
      end

      private

      def grid_options
        default_grid_options = { 'order' => 'updated_at',
                                 'page' => 1,
                                 'descending' => true }
        grid_params = params[:grid].present? ? params[:grid].permit(:descending, :order, :page, :title, :user, :status) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :grid_options

      def activity_grid_options
        default_grid_options = { 'order' => 'date',
                                 'page' => 1,
                                 'descending' => true,
                                 'item_id' => @post.id,
                                 'object' => 'Integral::Post' }
        grid_params = params[:grid].present? ? params[:grid].permit(:descending, :order, :page, :user, :action, :object) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :activity_grid_options

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        permitted_post_params = %i[title slug body description tag_list image_id preview_image_id status lock_version]

        permitted_post_params.concat Integral.additional_post_params
        params.require(:post).permit(*permitted_post_params)
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.navigation.dashboard'), :backend_dashboard_path
        add_breadcrumb I18n.t('integral.navigation.posts'), :backend_posts_path
      end

      def notification_message(namespace_type)
        super('posts', namespace_type)
      end
    end
  end
end
