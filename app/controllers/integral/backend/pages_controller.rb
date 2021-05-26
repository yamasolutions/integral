module Integral
  module Backend
    # Pages controller
    class PagesController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity]
      before_action :set_resource, except: %i[create new index list]

      # POST /
      # Resource creation
      def create
        super do
          @resource.active_block_list.listable = @resource
        end
      end

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        super do |cloned_resource|
          cloned_resource.title = "Copy #{@resource.title[0...Integral.title_length_maximum - 5]}"
          cloned_resource.path += "-#{SecureRandom.hex[1..5]}"
          cloned_resource.build_active_block_list(content: @resource.active_block_list.content, listable: cloned_resource)
        end
      end

      # @return [BasePolicy] current authorization policy
      def current_policy
        return policy(@page) if @page

        policy(Integral::Page.new)
      end
      helper_method :current_policy

      private

      # Unfortunately currently have to disable Turbolinks for Block Editor History to not bleed over
      def disable_turbolinks?
        action_name == 'new' || action_name == 'edit'
      end

      def resource_grid_columns
        columns = [:title, :path, :status]
        columns += [:locale] if Integral.multilingual_frontend?
        columns += [:updated_at, :actions]
      end

      def resource_params
        params.require(:page).permit(current_policy.permitted_attributes)
      end

      def white_listed_grid_params
        [ :descending, :order, :page, :search, status: [], locale: [] ]
      end

      def resource_klass
        Integral::Page
      end
    end
  end
end
