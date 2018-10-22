module Integral
  module Backend
    # Pages controller
    class PagesController < BaseController
      before_action :set_page, only: %i[edit update destroy activities activity]
      before_action :authorize_with_klass, only: %i[index new create edit update destroy]

      # GET /
      # Lists all pages
      def index
        respond_to do |format|
          format.html do
            set_grid(Integral::Grids::PagesGrid)
          end

          format.json do
            if params[:gridview].present?
              set_grid(Integral::Grids::PagesGrid)
              render json: { content: render_to_string(partial: 'integral/backend/pages/grid', locals: { grid: @grid }) }
            else
              respond_to_record_selector(Integral::Page)
            end
          end
        end
      end

      # GET /new
      # Page creation form
      def new
        add_breadcrumb I18n.t('integral.navigation.new'), :new_backend_page_path
        @page = Page.new
      end

      # POST /
      # Page creation
      def create
        @page = Page.new(page_params)

        if @page.save
          respond_successfully(notification_message('creation_success'), edit_backend_page_path(@page))
        else
          respond_failure(notification_message('creation_failure'), @page, :new)
        end
      end

      # GET /:id/edit
      # Page edit form
      def edit
        # add_breadcrumb @page.title, backend_page_url(@page)
        add_breadcrumb I18n.t('integral.navigation.edit'), :edit_backend_page_path
      end

      # PUT /:id
      # Updating an page
      def update
        if @page.update(page_params)
          respond_successfully(notification_message('edit_success'), edit_backend_page_path(@page))
        else
          respond_failure(notification_message('edit_failure'), @page, :edit)
        end
      end

      # DELETE /:id
      def destroy
        if @page.destroy
          respond_successfully(notification_message('delete_success'), backend_pages_path)
        else
          error_message = @page.errors.full_messages.to_sentence
          flash[:error] = "#{notification_message('delete_failure')} - #{error_message}"
          redirect_to backend_pages_path
        end
      end

      # GET /:id/activities
      def activities
        respond_with_activities(:edit_backend_page_url)
      end

      # GET /:id/activities/:id
      def activity
        authorize Version

        add_breadcrumb I18n.t('integral.navigation.activity'), :activities_backend_page_url
        add_breadcrumb I18n.t('integral.actions.view')

        @activity = PageVersion.find(params[:activity_id]).decorate
      end

      # @return [BasePolicy] current authorization policy
      def current_policy
        return policy(@page) if @page
        policy(Integral::Page.new)
      end
      helper_method :current_policy

      private

      def grid_options
        default_grid_options = { 'order' => 'updated_at',
                                 'page' => 1,
                                 'descending' => true }
        grid_params = params[:grid].present? ? params[:grid].permit(:descending, :order, :page, :title, :status) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :grid_options

      def activity_grid_options
        default_grid_options = { 'order' => 'date',
                                 'page' => 1,
                                 'descending' => true,
                                 'item_id' => @page&.id,
                                 'object' => 'Integral::Page' }
        grid_params = params[:grid].present? ? params[:grid].permit(:descending, :order, :page, :user, :action, :object) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :activity_grid_options

      def authorize_with_klass
        authorize Page
      end

      def set_page
        @page = Page.find(params[:id])
      end

      def page_params
        params.require(:page).permit(current_policy.permitted_attributes)
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.navigation.dashboard'), :backend_dashboard_path
        add_breadcrumb I18n.t('integral.navigation.pages'), :backend_pages_path
      end

      def notification_message(namespace_type)
        super('pages', namespace_type)
      end
    end
  end
end
