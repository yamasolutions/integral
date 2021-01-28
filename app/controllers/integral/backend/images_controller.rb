module Integral
  module Backend
    # Images controller
    class ImagesController < BaseController
      before_action :set_resource, except: %i[create index new list]
      before_action :authorize_with_klass, except: %i[activities activity]
      skip_before_action :verify_authenticity_token, only: [:create]

      # GET /new
      # Image creation form
      def new
        add_breadcrumb I18n.t('integral.navigation.new'), :new_backend_img_path
        @resource = Image.new
      end

      # POST /
      # Image creation
      def create
        @resource = Image.new(resource_params)

        if remote_request?
          if @resource.save
            flash.now[:notice] = notification_message('creation_success')
            render json: @resource.to_list_item, status: :created
          else
            flash.now[:error] = notification_message('creation_failure')
            head :unprocessable_entity
          end
        elsif @resource.save
          respond_successfully(notification_message('creation_success'), edit_backend_img_path(@resource))
        else
          respond_failure(notification_message('creation_failure'), :new)
        end
      end

      # PUT /:id
      # Updating an image
      def update
        if @resource.update(resource_params)
          respond_successfully(notification_message('edit_success'), backend_img_index_path)
        else
          respond_failure(notification_message('edit_failure'), :edit)
        end
      end

      # DELETE /:id
      def destroy
        if @resource.destroy
          respond_successfully(notification_message('delete_success'), backend_img_index_path)
        else
          flash[:error] = notification_message('delete_failure')
          redirect_to backend_img_index_path
        end
      end

      private

      def resource_klass
        Integral::Image
      end

      def new_backend_resource_url
        new_backend_img_url
      end

      def activities_backend_resource_url(resource)
        activities_backend_img_url(resource)
      end

      def list_backend_resources_url
        list_backend_img_index_url
      end

      def backend_resources_url
        backend_img_index_url
      end

      def backend_resource_url(resource)
        backend_img_url(resource)
      end

      def edit_backend_resource_url(resource)
        edit_backend_img_url(resource)
      end

      def remote_request?
        params[:image][:remote].present?
      end

      def resource_params
        params.require(:image).permit(:title, :description, :file, :lock_version)
      end

      def set_breadcrumbs
        add_breadcrumb I18n.t('integral.navigation.dashboard'), :backend_dashboard_path
        add_breadcrumb I18n.t('integral.navigation.images'), :backend_img_index_path
      end

      def white_listed_grid_params
        %i[descending order page title]
      end
    end
  end
end
