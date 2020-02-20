module Integral
  module Backend
    # Audits controller
    class AuditsController < BaseController
      private

      def white_listed_grid_params
        %i[descending order page user action object title]
      end

      def resource_klass
        Integral::Lighthouse::Audit
      end
    end
  end
end
