module Integral
  module Backend
    # List controller
    class ListsController < BaseController
      before_action :set_list, only: %i[edit update destroy show clone]
      before_action :authorize_with_klass
      before_action -> { set_grid(Integral::Grids::ListsGrid) }, only: [:index]

      # GET /
      # Lists all lists
      def index
        respond_to do |format|
          format.html
          format.json do
            render json: { content: render_to_string(partial: 'integral/backend/lists/grid', locals: { grid: @grid }) }
          end
        end
      end

      # GET /:id
      def show
        @list = List.find(params[:id])
        @list.list_items.order(:priority)

        add_breadcrumb @list.title, :backend_list_path
      end

      # GET /new
      # List creation form
      def new
        add_breadcrumb I18n.t('integral.breadcrumbs.new'), :new_backend_list_path
        @list = List.new
      end

      # POST /
      # List creation
      def create
        @list = List.new(list_params)

        if @list.save
          respond_successfully(notification_message('creation_success'), backend_list_path(@list))
        else
          respond_failure(notification_message('creation_failure'), @list, :new)
        end
      end

      # GET /:id/edit
      # List edit form
      def edit
        add_breadcrumb @list.title, :backend_list_path
        add_breadcrumb I18n.t('integral.breadcrumbs.edit'), :edit_backend_list_path
      end

      # GET /:id/clone
      # Clone a list
      def clone
        title = params[:title].present? ? params[:title] : "#{@list.title} Copy"
        title = "#{title} #{SecureRandom.hex[1..5]}" if Integral::List.find_by_title(title).present?

        cloned_list = @list.dup(title)

        if cloned_list.save
          respond_successfully(notification_message('creation_success'), backend_list_path(cloned_list))
        else
          respond_failure(notification_message('creation_failure'), @list, :edit)
        end
      end

      # PUT /:id
      # Updating an list
      def update
        if @list.update(list_params)
          respond_successfully(notification_message('edit_success'), backend_list_path(@list))
        else
          respond_failure(notification_message('edit_failure'), @list, :show)
        end
      end

      # DELETE /:id
      def destroy
        if @list.destroy
          respond_successfully(notification_message('delete_success'), backend_lists_path)
        else
          error_message = @list.errors.full_messages.to_sentence
          flash[:error] = "#{notification_message('delete_failure')} - #{error_message}"
          redirect_to backend_lists_path
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

      def authorize_with_klass
        authorize List
      end

      def set_list
        @list = List.find(params[:id])
      end

      def list_params
        params.require(:list).permit(
          :title, :description, :html_id, :html_classes, :lock_version, :children, :list_item_limit,
          list_items_attributes: [
            :id, :type, :object_type, :object_id, :title, :subtitle, :url, :image_id, :target,
            :priority, :_destroy, :description, :html_classes,
            children_attributes: list_item_attributes
          ]
        )
      end

      def list_item_attributes
        %i[
          id type object_type object_id title url image_id
          target priority description subtitle html_classes _destroy
        ]
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_path
        add_breadcrumb I18n.t('integral.breadcrumbs.lists'), :backend_lists_path
      end

      def notification_message(namespace_type)
        super('lists', namespace_type)
      end
    end
  end
end
