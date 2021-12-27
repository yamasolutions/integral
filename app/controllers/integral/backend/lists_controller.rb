module Integral
  module Backend
    # List controller
    class ListsController < BaseController
      before_action :set_resource, except: %i[create index new list]
      before_action :authorize_with_klass, except: %i[activities activity]

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        super do |cloned_resource|
          cloned_resource.title = "Copy #{@resource.title}"
        end
      end

      private

      def white_listed_grid_params
        %i[descending order page search]
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
