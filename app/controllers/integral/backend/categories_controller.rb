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

      # Override redirect path
      # DELETE /:id
      def destroy
        if @resource.destroy
          respond_to do |format|
            format.html { respond_successfully(notification_message('delete_success'), send("backend_posts_path")) }
            format.js { head :no_content }
          end
        else
          respond_to do |format|
            format.html do
              error_message = @resource.errors.full_messages.to_sentence
              flash[:error] = "#{notification_message('delete_failure')} - #{error_message}"

              redirect_to send("backend_posts_path")
            end
            format.js { head :unprocessable_entity }
          end
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
