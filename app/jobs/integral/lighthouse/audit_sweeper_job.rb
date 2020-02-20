module Integral
  module Lighthouse
    # Creates Lighthouse audit jobs for eligible records
    class AuditSweeperJob < ApplicationJob
      # Perform sweep
      def perform
        Integral::ActsAsAuditable.objects.each do |auditable_type|
          auditable_type.auditable_scope.each do |auditable|
            audit = auditable.audits.last

            # Schedule audits for all eligible records which do not have an audit or have been updated since their last audit
            if audit.nil? || audit.created_at < auditable.updated_at
              schedule_job(auditable)
            end
          end
        end
      end

      private

      def schedule_job(auditable)
        url = "#{Rails.application.routes.default_url_options[:host]}#{auditable.auditable_path}"

        AuditJob.perform_later(url, object: auditable)
      end
    end
  end
end
