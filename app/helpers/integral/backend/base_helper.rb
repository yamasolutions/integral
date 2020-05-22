module Integral
  # View helper methods for Backend pages
  module Backend
    # Base Backend Helper
    module BaseHelper
      include Integral::SupportHelper

      # Override FontAwesomeSass icon Helper
      #
      # Font style is either passed in together with name
      # or not passed in and solid (fas) is assumed.
      def icon(name, text=nil, html_options={})
        name = name.to_s if name.is_a?(Symbol)

        if name.include?(' ')
          name << " #{html_options[:class]}" if html_options.key?(:class)
          html_options[:class] = name

          html = content_tag(:i, nil, html_options)
          html << ' ' << text.to_s unless text.blank?
          html
        else
          super('fas', name, text, html_options)
        end
      end

      def render_main_menu
        render_menu(extract_menu_items(Integral::ActsAsIntegral.backend_main_menu_items, :integral_backend_main_menu_item))
      end

      def render_create_menu
        render_menu(extract_menu_items(Integral::ActsAsIntegral.backend_create_menu_items, :integral_backend_create_menu_item))
      end

      def recent_user_notifications
        @recent_user_notifications ||= current_user.notifications.recent
      end

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

      # @return [String] Resource Grid Form
      def render_resource_grid_form(&block)
        if block_given?
          render(layout: "integral/backend/shared/grid/form", &block)
        else
          render(partial: "integral/backend/shared/grid/form")
        end
      end

      # @return [String] Resource Grid
      def render_resource_grid(locals = {})
        render(partial: "integral/backend/shared/grid/grid", locals: locals)
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

      def current_user_authorized_for_menu_item?(item)
        if item[:authorize]
          instance_eval(&item[:authorize])
        elsif item[:authorize_class] && item[:authorize_action]
          Pundit.policy(current_user, item[:authorize_class]).public_send("#{item[:authorize_action]}?")
        else
          true
        end
      end

      private

      def extract_menu_items(items, extract_method)
        items = items.map { |item| item.class == Class ? item.send(extract_method) : item }
      end

      def render_menu(items, options={})
        return '' if items.empty?

        output = ''
        items = items.sort_by { |item| item[:order] }

        items.each do |item|
          next unless current_user_authorized_for_menu_item?(item)

          if item[:list_items]&.any?
            output += content_tag :li do
              list = content_tag :ul do
                list_items = item[:list_items].map do |list_item|
                  next unless current_user_authorized_for_menu_item?(list_item)

                  link_to list_item[:label], list_item[:url], wrapper: :li
                end.join.html_safe
                list_items.prepend(content_tag(:li, item[:label]))
              end
              list.prepend(link_to(item[:label], item[:url], icon: item[:icon]))
            end
          else
            output += link_to item[:label], item[:url], wrapper: :li, icon: item[:icon]
          end
        end

        output.html_safe
      end
    end
  end
end
