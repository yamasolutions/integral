module Integral
  # View helper methods for Backend pages
  module Backend
    # Base Backend Helper
    module BaseHelper
      include Integral::SupportHelper

      def recent_user_notifications
        @recent_user_notifications ||= current_user.notifications.recent
      end

      # @return [String] Integral card
      def render_card(partial, locals = {})
        render(partial: "integral/backend/shared/cards/#{partial}", locals: locals)
      end

      # @return [Array] returns array of VersionDecorators subclassed depending on the Version subclass
      def recent_user_activity_grid
        @recent_user_activity_grid ||= begin
                                      options = { user: current_user.id }
                                      options[:object] = resource_klass.to_s if resource_klass.present?
                                      options[:item_id] = @resource.id if @resource.present?

                                      recent_activity_grid(options)
                                    end
      end

      # @return [Array] returns array of VersionDecorators subclassed depending on the Version subclass
      def recent_site_activity_grid
        @recent_site_activity_grid ||= begin
                                      options = {}
                                      options[:object] = resource_klass.to_s if resource_klass.present?
                                      options[:item_id] = @resource.id if @resource.present?

                                      recent_activity_grid(options)
                                    end
      end

      def recent_activity_grid(options)
        #Integral::Grids::ActivitiesGrid.new(options)
        Integral::Grids::ActivitiesGrid.new options do |scope|
          scope.where.not(whodunnit: nil)
        end
      end

      # @return [String] title provided through yield or i18n scoped to controller namespace & action
      def page_title
        return content_for(:title) if content_for?(:title)
        return t("devise.#{controller_name}.#{action_name}.title") if devise_controller?

        # Scope is set to current controller namespace & action
        t('title', scope: "#{controller_path.tr('/', '.')}.#{action_name}",
                   default: I18n.t("integral.backend.titles.#{action_name}",
                                   type_singular: resource_klass.model_name.human.capitalize,
                                   type_plural: resource_klass.model_name.human(count: 2).capitalize))
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
      def dataset_at_a_glance_posts
        [
          { scope: Integral::Post.published, label: 'Published' },
          { scope: Integral::Post.draft, label: 'Draft ' }
        ]
      end

      # Donut Graph - At a Glance
      def dataset_at_a_glance_pages
        [
          { scope: Integral::Page.published, label: 'Published' },
          { scope: Integral::Page.draft, label: 'Draft ' },
          { scope: Integral::Page.archived, label: 'Archived ' }
        ]
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
