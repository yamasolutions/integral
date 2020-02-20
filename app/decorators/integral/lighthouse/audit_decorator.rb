module Integral
  module Lighthouse
    # Audit view-level logic
    class AuditDecorator < Draper::Decorator
      delegate_all

      # @return [String] URL to backend activity
      def activity_url(activity_id)
        # Integral::Engine.routes.url_helpers.activity_backend_user_url(object.id, activity_id)
      end

      # @return [String] URL to backend list page
      def backend_url
        Integral::Engine.routes.url_helpers.backend_audit_url(self)
      end
    end
  end
end
