module Integral
  module Backend
    # Static (not related to a specific model) pages
    class StaticPagesController < BaseController
      # GET /
      # Dashboard to show website stats and other useful information
      def dashboard; end

      def resource_klass
        nil
      end

      private

      def set_breadcrumbs; end
    end
  end
end
