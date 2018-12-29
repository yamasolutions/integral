module Integral
  module Backend
    # Post management
    class PostsController < BaseController
      before_action :authorize_with_klass, only: %i[index new create edit update destroy]
      before_action :set_resource, only: %i[edit update destroy show activities activity]

      # POST /
      # Post creation
      def create
        @resource = Post.new(resource_params)
        @resource.user = current_user

        if @resource.save
          respond_successfully(notification_message('creation_success'), edit_backend_post_path(@resource.id))
        else
          respond_failure(notification_message('creation_failure'), :new)
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
