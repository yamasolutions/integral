module Integral
  module Storage
    # Storage File view-level logic
    class FileDecorator < Draper::Decorator
      delegate_all

      # # @return [String] URL to backend activity
      # def activity_url(activity_id)
      #   Integral::Engine.routes.url_helpers.activity_backend_img_url(object.id, activity_id)
      # end

      # @return [String] URL to backend page
      def backend_url
        Integral::Engine.routes.url_helpers.backend_storage_file_url(object)
      end
    end
  end
end
