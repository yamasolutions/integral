module Integral
  module Backend
    # Activity management
    class ActivitiesController < BaseController
      before_action :authorize_with_klass, except: [:widget]

      def widget
        activities = cast_activities(resource_grid.assets.where.not(whodunnit: nil).limit(10))
        last_created_at = activities.last.created_at.utc if activities.present?

        render json: { content: render_to_string(partial: 'integral/backend/activities/activity', collection: activities), last_created_at: last_created_at }
      end

      # GET /
      # Lists all activities
      def index
        respond_to do |format|
          format.html
          format.json do
            render json: { content: render_to_string(partial: "integral/backend/shared/grid/grid") }
          end
        end
      end

      private

      def list_backend_resources_url
        backend_activities_url
      end

      def backend_resource_url(resource)
        resource.url
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.breadcrumbs.dashboard'), :backend_dashboard_url
        add_breadcrumb I18n.t('integral.breadcrumbs.activity'), :backend_activities_url
      end

      def authorize_with_klass
        authorize Version
      end

      def resource_klass
        Integral::Version
      end

      def white_listed_grid_params
        [ :descending, :order, :page, :created_at, :item_id, object: [], action: [], user: [] ]
      end

      def default_resource_grid_options
        {
          'order' => 'date',
          'page' => 1,
          'descending' => true
        }
      end

      def render_default_action_bar?
        false
      end
    end
  end
end
