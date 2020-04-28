module Integral
  module Backend
    # List controller
    class ListsController < BaseController
      before_action :set_resource, except: %i[index new list]
      before_action :authorize_with_klass
      before_action -> { set_grid }, only: [:index]

      # GET /
      # Lists all lists
      def index
        respond_to do |format|
          format.html
          format.json do
            render json: { content: render_to_string(partial: 'integral/backend/lists/grid', locals: { grid: @grid }) }
          end
        end
      end

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        super do |cloned_resource|
          cloned_resource.title = "Copy #{@resource.title}"
        end
      end

      private

      def render_default_action_bar?
        false
      end

      def white_listed_grid_params
        %i[descending order page user action object title]
      end

      def resource_klass
        Integral::List
      end

      def set_resource
        @resource = List.find(params[:id])
        @resource.list_items&.order(:priority)
      end

      def resource_params
        params.require(:list).permit(
          :title, :description, :html_id, :html_classes, :lock_version, :children, :list_item_limit,
          list_items_attributes: [
            :id, :type, :object_type, :object_id, :title, :subtitle, :url, :image_id, :target,
            :priority, :_destroy, :description, :html_classes,
            children_attributes: list_item_attributes
          ]
        )
      end

      def list_item_attributes
        %i[
          id type object_type object_id title url image_id
          target priority description subtitle html_classes _destroy
        ]
      end
    end
  end
end
