module Integral
  module Lighthouse
    # Carries out Lighthouse Audits
    #
    # https://developers.google.com/web/tools/lighthouse
    # https://github.com/GoogleChrome/lighthouse/blob/master/docs/readme.md
    class AuditJob < ApplicationJob
      # Perform Lighthouse audit
      def perform(url, object: nil, emulated_form_factor: :mobile, categories: [:performance], throttling_method: :simulate)
        script = "yarn --silent lighthouse #{url} --output json --only-categories=#{categories.join} --quiet --no-enable-error-reporting --emulated-form-factor #{emulated_form_factor} --throttling-method #{throttling_method}"
        response = `#{script}`
        report = JSON.parse(response)

        create_audit(url: url,
                     emulated_form_factor: emulated_form_factor,
                     categories: categories.join,
                     throttling_method: throttling_method,
                     response: report,
                     object: object)
      end

      private

      def create_audit(params)
        audit = Audit.new(params.except(:object))

        params[:response]['categories'].each do |k, v|
          audit.public_send("#{k}_score=", v['score'])
        end

        if params[:object]
          audit.auditable_id = object.id
          audit.auditable_type = object.class
        end

        audit.save!
      end
    end
  end
end
