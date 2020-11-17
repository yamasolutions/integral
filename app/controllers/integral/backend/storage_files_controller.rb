module Integral
  module Backend
    # Storage files controller
    class StorageFilesController < BaseController

      # POST /
      # Resource creation
      def create
        @resource = resource_klass.new(resource_params)

        if @resource.save
          render json: { uploadURL: main_app.url_for(@resource.attachment) }, status: :created
        else
          head :unprocessable_entity
        end
      end

      private

      def respond_to_record_selector
        # TODO: This is currently case sensitive
        records = resource_klass.joins(attachment_attachment: :blob).
          where("active_storage_blobs.content_type LIKE ?", "image/%").
          where("integral_files.title LIKE ?", "%#{params[:search]}%").
          order('integral_files.updated_at DESC').
          paginate(page: params[:page])

        render json: { content: render_to_string(partial: 'integral/backend/shared/record_selector/collection', locals: { collection: records }) }
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

