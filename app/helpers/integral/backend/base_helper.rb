require "webpacker/helper"

module Integral
  # View helper methods for Backend pages
  module Backend
    # Base Backend Helper
    module BaseHelper
      include Integral::SupportHelper
      include ::Webpacker::Helper

      def storage_file_content_type_options
        ActiveStorage::Blob.distinct.pluck(:content_type).sort
      end

      def grouped_page_parent_options
        @resource.available_parents.order('updated_at DESC').group_by(&:locale).map do |result|
          [
            t("language.#{result[0]}"),
            result[1].map { |page| [ "#{page.title} - #{page.path} (##{page.id})", page.id ] }
          ]
        end.to_h
      end

      def grouped_post_alternate_options
        Integral::Post.published.where.not(id: @resource.id).order('updated_at DESC').group_by(&:locale).map do |result|
          [
            t("language.#{result[0]}"),
            result[1].map { |post| ["#{post.title} - #{post.slug} (##{post.id})", post.id, {disabled: @resource.alternate_ids.include?(post.id), data: { title: post.title, description: post.description, path: post.slug, url: backend_post_url(post.id) } }] }
          ]
        end.to_h
      end

      def grouped_page_alternate_options
        Integral::Page.published.where.not(id: @resource.id).order('updated_at DESC').group_by(&:locale).map do |result|
          [
            t("language.#{result[0]}"),
            result[1].map { |page| ["#{page.title} - #{page.path} (##{page.id})", page.id, {disabled: @resource.alternate_ids.include?(page.id), data: { title: page.title, description: page.description, path: page.path, url: backend_page_url(page.id) } }] }
          ]
        end.to_h
      end

      def current_webpacker_instance
        Integral.webpacker
      end

      def decorated_current_user
        @decorated_current_user ||= current_user.decorate
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
          { scope: Integral::Storage::File, label: 'Files' },
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

      def main_menu_items
        extract_menu_items(Integral::ActsAsIntegral.backend_main_menu_items, :integral_backend_main_menu_item).sort_by { |item| item[:order] }
      end

      def render_main_menu
        render_menu(extract_menu_items(Integral::ActsAsIntegral.backend_main_menu_items, :integral_backend_main_menu_item))
      end

      def render_create_menu
        render_menu(extract_menu_items(Integral::ActsAsIntegral.backend_create_menu_items, :integral_backend_create_menu_item))
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
