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

      # GET /:id
      # Show resource
      def show
        add_breadcrumb I18n.t('integral.navigation.list'), list_backend_resources_url
        add_breadcrumb I18n.t('integral.actions.view')
      end

      # GET /
      # Resource dashboard
      def index; end

      # GET /list
      # Lists all resources
      def list
        add_breadcrumb I18n.t('integral.navigation.list'), list_backend_resources_url

        respond_to do |format|
          format.html
          format.json do
            if params[:gridview].present?
              render json: { content: render_to_string(partial: "integral/backend/shared/grid/grid") }
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
        add_breadcrumb I18n.t('integral.actions.view'), backend_resource_url(@resource)
        add_breadcrumb I18n.t('integral.actions.edit')
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
          respond_to do |format|
            format.html { respond_successfully(notification_message('delete_success'), send("backend_#{controller_name}_path")) }
            format.js { head :no_content }
          end
        else
          respond_to do |format|
            format.html do
              error_message = @resource.errors.full_messages.to_sentence
              flash[:error] = "#{notification_message('delete_failure')} - #{error_message}"

              redirect_to send("backend_#{controller_name}_path")
            end
            format.js { head :unprocessable_entity }
          end

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

        add_breadcrumb I18n.t('integral.actions.view'), backend_resource_url(@resource)
        add_breadcrumb I18n.t('integral.navigation.activity')

        @grid = Integral::Grids::ActivitiesGrid.new(activity_grid_options.except('page')) do |scope|
          scope.page(activity_grid_options['page']).per_page(25)
        end

        respond_to do |format|
          format.html { render template: 'integral/backend/activities/shared/index', locals: { form_url: activities_backend_resource_url(@resource) } }
          format.json { render json: { content: render_to_string(partial: 'integral/backend/activities/shared/grid', locals: { grid: @grid }) } }
        end
      end

      # GET /:id/activities/:id
      def activity
        authorize Version

        add_breadcrumb I18n.t('integral.navigation.activity'), activities_backend_resource_url(@resource)
        add_breadcrumb I18n.t('integral.actions.view')

        @activity = resource_version_klass.find(params[:activity_id]).decorate

        render template: 'integral/backend/activities/shared/show', locals: { record: @resource.decorate }
      end

      private

      # Redirect user to integral dashboard after successful signup
      def after_accept_path_for(user)
        user.active!

        integral.backend_dashboard_path
      end

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

      helper_method :decorated_resource
      def decorated_resource
        @decorated_resource ||= @resource.decorate
      end

      helper_method :resource_grid
      def resource_grid
        @resource_grid ||= resource_grid_klass.new(grid_options.except('page')) do |scope|
          scope.page(grid_options['page']).per_page(25)
        end
      end

      helper_method :render_default_action_bar?
      def render_default_action_bar?
        action_name == 'index' || action_name == 'show'
      end

      helper_method :new_backend_resource_url
      def new_backend_resource_url
        send("new_backend_#{resource_klass.model_name.singular_route_key}_url")
      end

      helper_method :list_backend_resources_url
      def list_backend_resources_url
        send("list_backend_#{resource_klass.model_name.route_key}_url")
      end

      helper_method :activities_backend_resource_url
      def activities_backend_resource_url(resource)
        send("activities_backend_#{controller_name.singularize}_url", resource.id)
      end

      helper_method :backend_resource_url
      def backend_resource_url(resource)
        send("backend_#{resource_klass.model_name.singular_route_key}_url", resource)
      end

      helper_method :edit_backend_resource_url
      def edit_backend_resource_url(resource)
        send("edit_backend_#{resource_klass.model_name.singular_route_key}_url", resource)
      end

      helper_method :duplicate_backend_resource_url
      def duplicate_backend_resource_url(resource)
        send("duplicate_backend_#{resource_klass.model_name.singular_route_key}_url", resource)
      end

      helper_method :activities_backend_resource_url
      def activities_backend_resource_url(resource)
        send("activities_backend_#{resource_klass.model_name.singular_route_key}_url", resource)
      end

      helper_method :resource_klass
      def resource_klass
        controller_name.classify.constantize
      end

      helper_method :dataset_at_a_glance
      def dataset_at_a_glance
        if resource_klass.respond_to?(:statuses)
          resource_klass.statuses.keys.map do |status|
            { scope: resource_klass.send(status), label: t("integral.statuses.#{status}") }
          end
        else
          [
            { scope: resource_klass.all, label: "All #{resource_klass.model_name.human.pluralize}" }
          ]
        end
      end

      helper_method :cast_activities
      def cast_activities(activites)
        activites.map do |version|
          version.becomes(version.item_type.constantize.paper_trail.version_class).decorate
        end
      end

      def resource_grid_klass
        "Integral::Grids::#{controller_name.classify.pluralize}Grid".constantize
      end

      def resource_version_klass
        "#{resource_klass}Version".constantize
      end

      def set_resource
        scope = ['activities', 'activity'].include?(action_name) ? resource_klass.unscoped : resource_klass

        @resource = scope.find(params[:id])
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
