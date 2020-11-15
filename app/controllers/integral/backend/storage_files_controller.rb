module Integral
  module Backend
    # Storage files controller
    class StorageFilesController < BaseController

      # POST /
      # Resource creation
      def create
        @resource = resource_klass.new(resource_params)

        if @resource.save
          flash.now[:notice] = notification_message('creation_success')
          # render json: @resource.to_list_item, status: :created
          render json: {}, status: :created
        else
          flash.now[:error] = notification_message('creation_failure')
          head :unprocessable_entity
        end
      end

      private

      def resource_klass
        Integral::Storage::File
      end

      def resource_grid_klass
        Integral::Grids::FilesGrid
      end

      def white_listed_grid_params
        %i[descending order page user action object title]
      end

      def resource_params
        params.require(:storage_file).permit(:title, :description, :attachment)
      end
    end
  end
end

