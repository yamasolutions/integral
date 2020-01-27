module Integral
  # Backend module [Users only area]
  module Backend
    # Base controller for backend inherited by all Integral backend controllers
    class BaseController < ActionController::Base
      rescue_from ActiveRecord::StaleObjectError do |_exception|
        respond_to do |format|
          format.html do
            stale_record_recovery_action
          end
          format.xml  { head :conflict }
          format.json { head :conflict }
        end
      end

      protect_from_forgery with: :exception # Prevent CSRF attacks by raising an exception.

      layout :layout_by_resource # Set layout

      before_action :authenticate_user! # User Auth
      before_action :set_locale # User custom locale
      before_action :set_breadcrumbs # Breadcrumbs
      before_action :set_paper_trail_whodunnit # Track user activity via paper_trail

      # User authorization
      include Pundit
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      # GET /
      # Lists all resources
      def index
        respond_to do |format|
          format.html do
            set_grid
          end

          format.json do
            if params[:gridview].present?
              set_grid
              render json: { content: render_to_string(partial: "integral/backend/#{controller_name}/grid", locals: { grid: @grid }) }
            else
              respond_to_record_selector
            end
          end
        end
      end

      # GET /new
      # Resource creation screen
      def new
        add_breadcrumb I18n.t('integral.navigation.new'), "new_backend_#{controller_name.singularize}_path".to_sym
        @resource = resource_klass.new
      end

      # POST /
      # Resource creation
      def create
        add_breadcrumb I18n.t('integral.navigation.create'), "new_backend_#{controller_name.singularize}_path".to_sym
        @resource = resource_klass.new(resource_params)

        yield if block_given?

        if @resource.save
          respond_successfully(notification_message('creation_success'), send("edit_backend_#{controller_name.singularize}_path", @resource.id))
        else
          respond_failure(notification_message('creation_failure'), :new)
        end
      end

      # GET /:id/edit
      # Resource edit screen
      def edit
        add_breadcrumb I18n.t('integral.navigation.edit'), "edit_backend_#{controller_name.singularize}_path".to_sym
      end

      # PUT /:id
      # Updating a resource
      def update
        if @resource.update(resource_params)
          respond_successfully(notification_message('edit_success'), send("edit_backend_#{controller_name.singularize}_path", @resource.id))
        else
          respond_failure(notification_message('edit_failure'), :edit)
        end
      end

      # DELETE /:id
      def destroy
        if @resource.destroy
          respond_successfully(notification_message('delete_success'), send("backend_#{controller_name}_path"))
        else
          error_message = @resource.errors.full_messages.to_sentence
          flash[:error] = "#{notification_message('delete_failure')} - #{error_message}"

          redirect_to send("backend_#{controller_name}_path")
        end
      end

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        cloned_resource = @resource.dup

        yield cloned_resource if block_given?

        if cloned_resource.save
          respond_successfully(notification_message('clone_success'), send("edit_backend_#{controller_name.singularize}_path", cloned_resource.id))
        else
          respond_failure(notification_message('clone_failure'), :edit)
        end
      end

      # GET /:id/activities
      def activities
        authorize Version

        add_breadcrumb I18n.t('integral.navigation.edit'), "edit_backend_#{controller_name.singularize}_path".to_sym
        add_breadcrumb I18n.t('integral.navigation.activity')

        @grid = Integral::Grids::ActivitiesGrid.new(activity_grid_options.except('page')) do |scope|
          scope.page(activity_grid_options['page']).per_page(25)
        end

        respond_to do |format|
          format.html
          format.json { render json: { content: render_to_string(partial: 'integral/backend/activities/shared/grid', locals: { grid: @grid }) } }
        end
      end

      # GET /:id/activities/:id
      def activity
        authorize Version

        add_breadcrumb I18n.t('integral.navigation.activity'), "activities_backend_#{controller_name.singularize}_url".to_sym
        add_breadcrumb I18n.t('integral.actions.view')

        @activity = resource_version_klass.find(params[:activity_id]).decorate
      end

      private

      # Redirect user to integral dashboard after successful login
      def after_sign_in_path_for(_resource)
        integral.backend_dashboard_path
      end

      # Redirect user to integral dashboard after successful logout
      def after_sign_out_path_for(_resource_or_scope)
        integral.backend_dashboard_path
      end

      def user_not_authorized
        flash[:alert] = I18n.t('errors.unauthorized')
        redirect_to(backend_dashboard_path)
      end

      # Handle custom devise layouts
      # https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
      # Can't do it pretty way as have no access to Application.rb within Engine (?)
      def layout_by_resource
        if devise_controller?
          'integral/login'
        else
          'integral/backend'
        end
      end

      def set_locale
        I18n.locale = current_user.locale if current_user.present?
      end

      def respond_to_record_selector
        records = resource_klass.search(params[:search]).order('updated_at DESC').paginate(page: params[:page])
        render json: { content: render_to_string(partial: 'integral/backend/shared/record_selector/collection', locals: { collection: records }) }
      end

      def respond_successfully(flash_message, redirect_path)
        flash[:notice] = flash_message
        redirect_to redirect_path
      end

      def respond_failure(message, template, record = nil)
        record = @resource if record.nil?

        error_message = record.errors.full_messages.to_sentence
        flash.now[:error] = "#{message} - #{error_message}"
        render template, status: :unprocessable_entity
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.navigation.dashboard'), :backend_dashboard_path
        add_breadcrumb I18n.t("integral.navigation.#{controller_name}"), "backend_#{controller_name}_path".to_sym
      end

      def stale_record_recovery_action
        flash.now[:error] = 'Overwrite prevented. Another user has changed this record ' \
                            'since you accessed the edit form.'
        render :edit, status: :conflict
      end

      def notification_message(type_namespace, object_namespace = nil)
        object_namespace = controller_name if object_namespace.nil?

        I18n.t("integral.backend.#{object_namespace}.notification.#{type_namespace}",
               default: I18n.t("integral.backend.notifications.#{type_namespace}", type: resource_klass.model_name.human))
      end

      def set_grid
        @grid = resource_grid_klass.new(grid_options.except('page')) do |scope|
          scope.page(grid_options['page']).per_page(25)
        end
      end

      helper_method :resource_klass
      def resource_klass
        controller_name.classify.constantize
      end

      def resource_grid_klass
        "Integral::Grids::#{controller_name.classify.pluralize}Grid".constantize
      end

      def resource_version_klass
        "#{resource_klass}Version".constantize
      end

      def set_resource
        @resource = resource_klass.find(params[:id])
      end

      def grid_options
        default_grid_options = { 'order' => 'updated_at',
                                 'page' => 1,
                                 'descending' => true }
        grid_params = params[:grid].present? ? params[:grid].permit(*white_listed_grid_params) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :grid_options

      def activity_grid_options
        default_grid_options = { 'order' => 'date',
                                 'page' => 1,
                                 'descending' => true,
                                 'item_id' => @resource.id,
                                 'object' => resource_klass.to_s }
        grid_params = params[:grid].present? ? params[:grid].permit(*white_listed_grid_params) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        default_grid_options.merge(grid_params)
      end
      helper_method :activity_grid_options

      def white_listed_grid_params
        raise NotImplementedError, 'Specify the accepted grid parameters'
      end

      def authorize_with_klass
        authorize resource_klass
      end
    end
  end
end
