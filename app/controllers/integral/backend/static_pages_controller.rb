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

      def dataset_at_a_glance
        data = [
          { scope: Integral::Page, label: 'Total Pages' },
          { scope: Integral::List, label: 'Total Lists' },
          { scope: Integral::Image, label: 'Total Images' },
          { scope: Integral::User, label: 'Total Users' }
        ]

        data.prepend(scope: Integral::Post, label: 'Total Posts') if Integral.blog_enabled?
        data
      end

      def set_breadcrumbs; end
    end
  end
end
