module Integral
  module Backend
    # Categories controller
    class CategoriesController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity]
      before_action :set_resource, except: %i[create new index list]

      # PUT /:id
      # Updating a resource
      def update
        if @resource.update(resource_params)
          flash.now[:notice] = notification_message('edit_success')
          render json: { redirect_url: request.referrer }, status: :created
        else
          render json: { message: notification_message('edit_failure') }, status: :unprocessable_entity
        end
      end

      # GET /:id/edit
      # Category update screen
      def edit
        render json: { content: render_to_string(partial: 'integral/backend/categories/modal', locals: { category: @resource, title: 'Edit Category', modal_id: "modal--category-edit-#{@resource.id}" }) }
      end

      # POST /
      # Category creation
      def create
        @resource = Integral::Category.new(resource_params)

        if @resource.save
          flash.now[:notice] = notification_message('creation_success')
          render json: { redirect_url: request.referrer }, status: :created
        else
          render json: { message: notification_message('creation_failure') }, status: :unprocessable_entity
        end
      end

      private

      def resource_params
        params.require(:category).permit(:title, :slug, :description, :locale, :image_id)
      end

      def resource_klass
        Integral::Category
      end
    end
  end
end
