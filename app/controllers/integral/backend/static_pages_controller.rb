module Integral
  module Backend
    # Static (not related to a specific model) pages
    class StaticPagesController < BaseController
      # GET /
      # Dashboard to show website stats and other useful information
      def dashboard
        @recent_activity = Integral::Grids::ActivitiesGrid.scope.limit(5).map do |version|
          # Rails casts all the versions to UserVersion - need to recast before decorating
          version.becomes(version.item_type.constantize.paper_trail.version_class).decorate
        end
      end

      private

      def set_breadcrumbs; end
    end
  end
end
