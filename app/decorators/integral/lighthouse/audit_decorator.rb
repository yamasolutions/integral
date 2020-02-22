module Integral
  module Lighthouse
    # Audit view-level logic
    class AuditDecorator < Draper::Decorator
      delegate_all
      decorates_association :auditable

      def performance_score
        format_score(object.performance_score)
      end

      def formatted_url
        host = Rails.application.routes.default_url_options[:host]
        formatted = url
        formatted = url.split(host)[1] if url.starts_with?(host)

        formatted.truncate(40)
      end

      # @return [String] URL to backend activity
      def activity_url(activity_id)
        # Integral::Engine.routes.url_helpers.activity_backend_user_url(object.id, activity_id)
      end

      # @return [String] URL to backend list page
      def backend_url
        Integral::Engine.routes.url_helpers.backend_audit_url(self)
      end

      private

      def format_score(original_score)
        helpers.number_with_precision(original_score * 100, precision: 0)
      end
    end
  end
end
