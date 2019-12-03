module Integral
  # View helper methods for Backend pages
  module Backend
    # Base Backend Helper
    module BaseHelper
      include Integral::SupportHelper

      # @return [String] title provided through yield or i18n scoped to controller namespace & action
      def page_title
        return content_for(:title) if content_for?(:title)

        # Scope is set to current controller namespace & action
        t('title', scope: "#{controller_path.tr('/', '.')}.#{action_name}")
      end

      # Renders a grid from a local partial within a datagrid container
      def render_data_grid
        unless block_given?
          return content_tag(:div, render(partial: 'grid', locals: { grid: @grid }), data: { 'grid' => true, 'form' => 'grid_form' })
        end

        content_tag :div, data: { 'grid' => true, 'form' => 'grid_form' } do
          yield
        end
      end

      # Data which is embedded into the backend <body> tag
      def body_data_attributes
        {
          locale: I18n.locale,
          'user-name' => current_user.name,
          'user-email' => current_user.email,
          'user-created-at' => current_user.created_at.to_i
        }
      end

      # Backend Google Tag Manager Snippet
      # @return [String] GTM Container if ID has been supplied
      def google_tag_manager(type = :script)
        GoogleTagManager.render(Integral.gtm_container_id, type)
      end

      # Renders a line chart
      def render_line_chart(dataset)
        ChartRenderer::Line.render(dataset)
      end

      # Renders a donut chart
      def render_donut_chart(dataset)
        ChartRenderer::Donut.render(dataset)
      end

      # Donut Graph - At a Glance
      def dataset_dashboard_atg
        data = [
          { scope: Integral::Page, label: 'Total Pages' },
          { scope: Integral::List, label: 'Total Lists' },
          { scope: Integral::Image, label: 'Total Images' },
          { scope: Integral::User, label: 'Total Users' }
        ]

        data.prepend(scope: Integral::Post, label: 'Total Posts') if Integral.blog_enabled?
        data
      end

      # Line graph - Last week
      def dataset_dashboard_last_week
        data = [
          { scope: Integral::Page, label: 'Pages' },
          { scope: Integral::List, label: 'Lists' },
          { scope: Integral::Image, label: 'Images' },
          { scope: Integral::User, label: 'Users' }
        ]

        data.prepend(scope: Integral::Post, label: 'Posts') if Integral.blog_enabled?
        data
      end
    end
  end
end
