module Integral
  # View helper methods for Backend pages
  module Backend
    # Base Backend Helper
    module BaseHelper
      include Integral::SupportHelper

      # Handles extra optional options to `link_to` - Font awesome icons & wrapper
      def link_to(name = nil, options = nil, html_options = nil, &block)
        return super if block_given?
        return super if html_options.nil?

        if html_options[:icon]
          name = content_tag(:span, name)
          name.prepend(icon(html_options.delete(:icon)))
        end

        if html_options[:wrapper]
          wrapper = html_options.delete(:wrapper)
          if wrapper == :cell
            content_tag(:div, super(name, options, html_options, &block), class: 'cell')
          else
            content_tag(wrapper, super(name, options, html_options, &block))
          end
        else
          super(name, options, html_options, &block)
        end
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
        Integral::Grids::ActivitiesGrid.new(options)
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
    end
  end
end
