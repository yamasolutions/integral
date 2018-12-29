module Integral
  module Backend
    # Activity management
    class ActivitiesController < BaseController
      before_action :authorize_with_klass
      before_action -> { set_grid }

      # POST /grid
      # AJAX grid for activities
      # TODO: Could move this grid action into index action and respond different if json request
      def grid
        render json: { content: render_to_string(partial: 'integral/backend/activities/grid',
                                                 locals: { grid: @grid }) }
      end

      # GET /
      # Lists all activities
      def index; end

      # TODO: Implement this or some particular versioned one through routes.
      #
      # /admin/pages/activity -> All Page activity
      # /admin/pages/:id/activity -> Specific Page activity
      #
      # /admin/posts/activity -> All Page activity
      # /admin/posts/:id/activity -> Specific Page activity
      #
      # etc
      #
      # # GET /activity:id
      # # View an Activity
      # def show
      #   @activity = Integral::Version.find(params[:id])
      # end

      private

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_url
        add_breadcrumb I18n.t('integral.breadcrumbs.activity'), :backend_activities_url
      end

      def authorize_with_klass
        authorize Version
      end

      def grid_options
        grid_params = params[:grid].present? ? params[:grid].permit(:descending, :order, :page, :user, :action, :object) : {}
        grid_params.delete_if { |_k, v| v.empty? }
        { 'order' => 'date', 'page' => 1, descending: true }.merge(grid_params)
      end
      helper_method :grid_options
    end
  end
end
