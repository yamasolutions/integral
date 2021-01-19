module Integral
  module Backend
    # Post management
    class PostsController < BaseController
      before_action :authorize_with_klass, except: %i[activities activity]
      before_action :set_resource, except: %i[create new index list]

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        super do |cloned_resource|
          cloned_resource.title = "Copy #{@resource.title[0...Integral.title_length_maximum - 5]}"
          cloned_resource.view_count = 0
          cloned_resource.tag_list = @resource.tag_list_on(@resource.tag_context)
          cloned_resource.slug = @resource.slug
          cloned_resource.status = :draft
          cloned_resource.published_at = nil
        end
      end

      # GET /new
      # Post creation screen
      def new
        super
        @resource.user = current_user
      end

      private

      # Unfortunately currently have to disable Turbolinks for Block Editor History to not bleed over
      def disable_turbolinks?
        action_name == 'new' || action_name == 'edit'
      end

      def resource_grid_columns
        columns = [:title, :category, :status]
        columns += [:locale] if Integral.multilingual_frontend?
        columns += [:view_count, :updated_at, :actions]
      end

      def resource_params
        permitted_post_params = %i[title slug body description tag_list image_id preview_image_id status lock_version locale user_id category_id]
        permitted_post_params.concat [ alternate_ids: [] ]
        permitted_post_params.concat [ { active_block_list_attributes: [ :id, :content ] } ]
        permitted_post_params.concat Integral.additional_post_params

        params.require(:post).permit(*permitted_post_params)
      end

      def white_listed_grid_params
        [ :descending, :order, :page, :title, status: [], locale: [], user: [] ]
      end

      def resource_klass
        Integral::Post
      end
    end
  end
end
