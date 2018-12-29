module Integral
  module Backend
    # Pages controller
    class PagesController < BaseController
      before_action :authorize_with_klass, only: %i[index new create edit update destroy]
      before_action :set_resource, only: %i[edit update destroy show activities activity]

      # @return [BasePolicy] current authorization policy
      def current_policy
        return policy(@page) if @page
        policy(Integral::Page.new)
      end
      helper_method :current_policy

      private

      def resource_params
        params.require(:page).permit(current_policy.permitted_attributes)
      end

      def white_listed_grid_params
        %i[descending order page user action object title status]
      end

      def resource_klass
        Integral::Page
      end
    end
  end
end
