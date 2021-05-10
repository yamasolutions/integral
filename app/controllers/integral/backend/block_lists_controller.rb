module Integral
  module Backend
    # Block Lists controller
    class BlockListsController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity]
      before_action :set_resource, only: %i[show edit update]

      def index
        redirect_to list_backend_block_lists_url
      end

      def show
        if params["_locale"].present?
          block_list = BlockEditor::BlockList.reusable.find(params[:id])
          res = {
            id: block_list.id,
            status: "publish",
            name: "wp_block",
            title: {
              raw: block_list.name
            },
            content: {
              raw: block_list.content
            }
          }

          render json: res, status: 200, layout: false
        else
          redirect_to edit_backend_block_list_url(@resource.id)
        end
      end

      # @return [BasePolicy] current authorization policy
      def current_policy
        policy(Integral::Page.new)
      end
      helper_method :current_policy

      # Maybe able to get rid of the content here
      def block_lists
        res = BlockEditor::BlockList.reusable.map { |block_list| { id: block_list.id, title: block_list.name, content: block_list.content } }

        render json: res, status: 200, layout: false
      end

      def wp_type
        render json: { "rest_base" => "block_list" }, status: 200, layout: false
      end

      def wp_types
        res = {
          "wp_block" => {
            "rest_base": "block_lists",
            "labels": {
              "singular_name": "Block Lists"
            }
          }
        }

        render json: res, status: 200, layout: false
      end

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

      def white_listed_grid_params
        [ :descending, :order, :page, :title ]
      end

      def resource_klass
        BlockEditor::BlockList
      end

      def authorize_with_klass
        Integral::Page
      end
    end
  end
end
