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
        ActsAsIntegral.backend_at_a_glance_card_items.map do |item|
          { scope: item, label: "Total #{item.model_name.human.pluralize}" }
        end
      end

      def set_breadcrumbs; end
    end
  end
end
