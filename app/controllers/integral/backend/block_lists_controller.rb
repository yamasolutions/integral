module Integral
  module Backend
    # Block Lists controller
    class BlockListsController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity]
      before_action :set_resource, except: %i[create new index list]

      def index
        redirect_to list_backend_block_lists_url
      end

      def show
        redirect_to edit_backend_block_list_url(@resource.id)
      end

      # @return [BasePolicy] current authorization policy
      def current_policy
        policy(Integral::Page.new)
      end
      helper_method :current_policy

      private

      # Unfortunately currently have to disable Turbolinks for Block Editor History to not bleed over
      def disable_turbolinks?
        action_name == 'new' || action_name == 'edit'
      end

      # def resource_grid_columns
      #   columns = [:title, :path, :status]
      #   columns += [:locale] if Integral.multilingual_frontend?
      #   columns += [:updated_at, :actions]
      # end

      def resource_params
        params.require(:block_list).permit(:name, :content)
      end

      # def white_listed_grid_params
      #   [ :descending, :order, :page, :title, status: [], locale: [] ]
      # end

      def resource_klass
        BlockEditor::BlockList
      end

      def authorize_with_klass
        Integral::Page
      end
    end
  end
end
