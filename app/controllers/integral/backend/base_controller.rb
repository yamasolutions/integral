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

      # Prevent CSRF attacks by raising an exception.
      protect_from_forgery with: :exception

      layout :layout_by_resource

      before_action :authenticate_user! # User Auth
      before_action :set_locale # User custom locale
      before_action :set_breadcrumbs # Breadcrumbs

      # Track user activity via paper_trail
      before_action :set_paper_trail_whodunnit

      # User authorization
      include Pundit
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def respond_with_activities(breadcrumb_url)
        authorize Version

        add_breadcrumb I18n.t('integral.navigation.edit'), breadcrumb_url
        add_breadcrumb I18n.t('integral.navigation.activity')

        @grid = Integral::Grids::ActivitiesGrid.new(activity_grid_options.except('page')) do |scope|
          scope.page(activity_grid_options['page']).per_page(25)
        end

        respond_to do |format|
          format.html
          format.json { render json: { content: render_to_string(partial: 'integral/backend/activities/shared/grid', locals: { grid: @grid }) } }
        end
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

      def respond_to_record_selector(klass)
        records = klass.search(params[:search]).order('updated_at DESC').paginate(page: params[:page])
        render json: { content: render_to_string(partial: 'integral/backend/shared/record_selector/collection', locals: { collection: records }) }
      end

      # def respond_to_record_selector_item(record)
      #   render json: {
      #     html: render_to_string('integral/backend/shared/record_selector/record',
      #                            layout: false,
      #                            locals: { :list_item => record.to_list_item }) }
      # end

      def respond_successfully(flash_message, redirect_path)
        flash[:notice] = flash_message
        redirect_to redirect_path
      end

      def respond_failure(message, record, template)
        error_message = record.errors.full_messages.to_sentence
        flash.now[:error] = "#{message} - #{error_message}"
        render template, status: :unprocessable_entity
      end

      # Abstract method. Override if providing breadcrumbs
      def set_breadcrumbs; end

      def stale_record_recovery_action
        flash.now[:error] = 'Overwrite prevented. Another user has changed this record ' \
                            'since you accessed the edit form.'
        render :edit, status: :conflict
      end

      def notification_message(object_namespace, type_namespace)
        I18n.t("integral.backend.#{object_namespace}.notification.#{type_namespace}")
      end

      def set_grid(grid_klass)
        @grid = grid_klass.new(grid_options.except('page')) do |scope|
          scope.page(grid_options['page']).per_page(25)
        end
      end
    end
  end
end
