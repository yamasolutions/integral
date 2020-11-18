module Integral
  module Backend
    # Storage files controller
    class StorageFilesController < BaseController

      # POST /
      # Resource creation
      def create
        @resource = resource_klass.new(resource_params)

        if @resource.save
          resource_data = @resource.to_list_item
          resource_data[:image] = main_app.url_for(resource_data[:image])
          render json: resource_data, status: :created
        else
          head :unprocessable_entity
        end
      end

      private

      def respond_to_resource_selector
        # TODO: This is currently case sensitive
        collection = resource_klass.joins(attachment_attachment: :blob).
          where("active_storage_blobs.content_type LIKE ?", "image/%").
          where("integral_files.title LIKE ?", "%#{params[:search]}%").
          order('integral_files.updated_at DESC').
          paginate(page: params[:page])

        render json: { content: render_to_string(partial: 'integral/backend/shared/resource_selector/collection', locals: { collection: collection }) }
      end

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

