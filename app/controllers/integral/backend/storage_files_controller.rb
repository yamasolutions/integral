module Integral
  module Backend
    # Storage files controller
    class StorageFilesController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity]
      before_action :set_resource, except: %i[create new index list]

      # GET /new
      # Resource creation screen
      def new
        add_breadcrumb I18n.t('integral.actions.upload')
        @resource = resource_klass.new
      end

      # POST /
      # Resource creation
      def create
        @resource = resource_klass.new(resource_params)

        if @resource.save
          resource_data = @resource.to_list_item
          resource_data[:image] = main_app.url_for(resource_data[:image].representation(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[:medium])))
          render json: resource_data, status: :created
        else
          head :unprocessable_entity
        end
      end

      private

      def respond_to_resource_selector
        page = params.fetch(:page, 1)
        options = {
          'order' => 'updated_at',
          'descending' => true,
          'type' => params.fetch(:type, nil),
          'title' => params.fetch(:search, nil)
        }

        collection = resource_grid_klass.new(options) do |scope|
          scope.page(page).per_page(24)
        end.assets

        render json: { content: render_to_string(partial: 'integral/backend/shared/resource_selector/collection', locals: { collection: collection }) }
      end

      def resource_klass
        Integral::Storage::File
      end

      def resource_grid_klass
        Integral::Grids::FilesGrid
      end

      def white_listed_grid_params
        %i[descending order page user action object title type]
      end

      def resource_params
        params.require(:storage_file).permit(:title, :description, :attachment)
      end

      def dataset_at_a_glance
        resource_klass.joins(attachment_attachment: :blob).distinct.pluck(:content_type).sort.map do |content_type|
          {
            scope: resource_klass.joins(attachment_attachment: :blob).where("active_storage_blobs.content_type = ?", content_type),
            label: content_type.truncate(30)
          }
        end
      end
    end
  end
end

