module Integral
  module Backend
    # Post management
    class PostsController < BaseController
      before_action :authorize_with_klass, only: %i[index new create edit update destroy]
      before_action :set_resource, only: %i[edit update destroy show activities activity duplicate]

      # POST /:id/duplicate
      # Duplicate a resource
      def duplicate
        super do |cloned_resource|
          cloned_resource.title = "#{@resource.title} #{SecureRandom.hex[1..5]}"
          cloned_resource.slug = @resource.slug
          cloned_resource.status = :draft
        end
      end

      # POST /
      # Post creation
      def create
        super do
          @resource.user = current_user
        end
      end

      private

      def resource_params
        permitted_post_params = %i[title slug body description tag_list image_id preview_image_id status lock_version]

        permitted_post_params.concat Integral.additional_post_params
        params.require(:post).permit(*permitted_post_params)
      end

      def resource_klass
        Integral::Post
      end
    end
  end
end
