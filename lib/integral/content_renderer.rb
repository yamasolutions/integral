module Integral
  # Handles the rendering of dynamic content (Widgets) within static HTML
  # A widget could be used to list recent articles from the blog, featured content from a list, etc
  #
  # Example Widget Markup
  # <p class='integral-widget' data-widget-type='recent_posts' data-widget-value-tagged='awesome-tag'>
  class ContentRenderer
    # Markup defining a widget
    PLACEHOLDER_SELECTOR = 'p.integral-widget'.freeze

    # @return [Array] available widgets used to render dynamic content
    def self.widgets
      widgets = [
        ['recent_posts', 'Integral::Widgets::RecentPosts'],
        ['swiper_list', 'Integral::Widgets::SwiperList']
      ]

      widgets.concat Integral.additional_widgets
    end

    # Renders WYSIWYG html, converting any widget placeholders to dynamic content
    #
    # @param raw_html [String]
    #
    # @return [String] Parsed content
    def self.render(raw_html)
      html = Nokogiri::HTML(raw_html)
      html.css(self::PLACEHOLDER_SELECTOR).each do |placeholder|
        widget_type = placeholder.attributes['data-widget-type']&.value

        placeholder.replace(render_widget(widget_type, widget_options(placeholder.attributes)))
      end

      html.css('body').inner_html.html_safe
    end

    # Parse placeholder attributes to find any widget options
    #
    # @param placeholder_attributes [Hash] raw placeholder attributes
    #
    # @return [Hash] widget options
    def self.widget_options(placeholder_attributes)
      options = {}
      keys = placeholder_attributes.keys.select { |key| key.starts_with?('data-widget-value-') }

      keys.each { |key| options[key.remove('data-widget-value-').to_sym] = placeholder_attributes[key].value }
      options
    end

    # Renders a specific widget using the provided options
    #
    # @param type [String] Type of widget to render
    # @param options [Hash] Widget options to use when rendering
    #
    # @return [String] widget content
    def self.render_widget(type, options)
      widget = widgets.find { |w| w[0] == type }

      return widget_not_available_message unless widget.present?

      widget[1].constantize.render(options)
    rescue StandardError => error
      respond_with_widget_error(error)
    end

    # Handles widget errors
    def self.respond_with_widget_error(error)
      Rails.logger.error(error.message)

      '<!-- Error rendering widget -->'
    end

    # @return [String] Widget not available message
    def self.widget_not_available_message
      '<!-- Widget not available -->'
    end
  end
end
