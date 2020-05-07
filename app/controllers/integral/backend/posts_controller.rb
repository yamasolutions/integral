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

      def resource_params
        permitted_post_params = %i[title slug body description tag_list image_id preview_image_id status lock_version user_id category_id]

        permitted_post_params.concat Integral.additional_post_params
        params.require(:post).permit(*permitted_post_params)
      end

      def white_listed_grid_params
        %i[descending order page user action object title status]
      end

      def resource_klass
        Integral::Post
      end
    end
  end
end
