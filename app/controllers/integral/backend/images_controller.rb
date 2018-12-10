module Integral
  module Backend
    # Images controller
    class ImagesController < BaseController
      before_action :set_image, only: %i[edit update destroy show]
      before_action :authorize_with_klass

      # GET /
      # Lists all images
      def index
        respond_to do |format|
          format.html do
            set_grid(Integral::Grids::ImagesGrid)
          end

          format.json do
            if params[:gridview].present?
              set_grid(Integral::Grids::ImagesGrid)
              render json: { content: render_to_string(partial: 'integral/backend/images/grid', locals: { grid: @grid }) }
            else
              respond_to_record_selector(Integral::Image)
            end
          end
        end
      end

      # GET /new
      # Image creation form
      def new
        add_breadcrumb I18n.t('integral.navigation.new'), :new_backend_img_path
        @image = Image.new
      end

      # POST /
      # Image creation
      def create
        @image = Image.new(image_params)

        if remote_request?
          if @image.save
            flash.now[:notice] = notification_message('creation_success')
            render json: @image.to_list_item, status: :created
          else
            flash.now[:error] = notification_message('creation_failure')
            head :unprocessable_entity
          end
        elsif @image.save
          respond_successfully(notification_message('creation_success'), edit_backend_img_path(@image))
        else
          respond_failure(notification_message('creation_failure'), @image, :new)
        end
      end

      # GET /:id/edit
      # Image edit form
      def edit
        add_breadcrumb I18n.t('integral.navigation.edit'), :edit_backend_img_path
      end

      # PUT /:id
      # Updating an image
      def update
        if @image.update(image_params)
          respond_successfully(notification_message('edit_success'), backend_img_index_path)
        else
          respond_failure(notification_message('edit_failure'), @image, :edit)
        end
      end

      # DELETE /:id
      def destroy
        if @image.destroy
          respond_successfully(notification_message('delete_success'), backend_img_index_path)
        else
          flash[:error] = notification_message('delete_failure')
          redirect_to backend_img_index_path
        end
      end

      private

      def grid_options
        default_grid_options = { 'order' => 'updated_at',
                                 'page' => 1,
                                 'descending' => true }
        grid_params = params[:grid].present? ? params[:grid].permit(:descending, :order, :page, :title) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :grid_options

      def remote_request?
        params[:image][:remote].present?
      end

      def authorize_with_klass
        authorize Image
      end

      def set_image
        @image = Image.find(params[:id])
      end

      def image_params
        params.require(:image).permit(:title, :description, :file, :lock_version)
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.navigation.dashboard'), :backend_dashboard_path
        add_breadcrumb I18n.t('integral.navigation.images'), :backend_img_index_path
      end

      def notification_message(namespace_type)
        super('images', namespace_type)
      end
    end
  end
end
