module Integral
  module Backend
    # Pages controller
    class PagesController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity block_editor]
      before_action :set_resource, except: %i[create new index list]
      # layout "integral/block_editor", only: [:block_editor]

      def block_editor
        render layout: 'integral/block_editor'
      end

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        super do |cloned_resource|
          cloned_resource.title = "Copy #{@resource.title[0...Integral.title_length_maximum - 5]}"
          cloned_resource.path += "-#{SecureRandom.hex[1..5]}"
        end
      end

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
