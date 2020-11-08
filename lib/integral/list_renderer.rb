module Integral
  # Handles safely rendering lists
  class ListRenderer
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Context

    attr_accessor :list, :opts

    # Renders the provided list with options given
    #
    # @return [String] the rendered list
    def self.render(list, opts = {})
      renderer = new(list, opts)
      renderer.render_safely.html_safe
    end

    # @param list [List] object to render
    # @param opts [Hash] options hash
    def initialize(list, opts = {})
      @opts = opts.reverse_merge(
        item_renderer: ListItemRenderer,
        item_renderer_opts: {},
        wrapper_element: 'ul'
      )

      @list = list
    end

    # Performs checks before rendering to see if provided list exists and contains list items
    def render_safely
      return render_no_list_warning if list.nil?
      return render_no_items_warning if list.list_items.empty?

      render
    end

    # Renders the provided list
    #
    # @return [String] the rendered list item
    def render
      rendered_items = ''

      list.list_items.each do |list_item|
        rendered_items += render_item(list_item)
      end

      if opts[:wrapper_element]
        content_tag opts[:wrapper_element], rendered_items, html_options, false
      else
        rendered_items
      end
    end

    private

    # @return [String] HTML comment informing nil argument was provided as the list
    def render_no_list_warning
      Rails.logger.debug('IntegralMessage: Tried to render a list with a nil argument.')
      '<!-- Warning: Tried to render a list with a nil argument. -->'
    end

    # @return [String] HTML comment informing list contains 0 items
    def render_no_items_warning
      Rails.logger.debug('IntegralMessage: Tried to render a list with no items.')
      '<!-- Warning: Tried to render a list with no items. -->'
    end

    def html_options
      opts = {}
      opts[:id] = html_id if html_id.present?
      opts[:class] = html_classes if html_classes.present?
      opts[:data] = self.opts[:data_attributes]

      opts
    end

    def render_item(item)
      opts[:item_renderer].render(item, opts[:item_renderer_opts])
    end

    def html_id
      return list.html_id if list.html_id.present?
      return opts[:html_id] if opts[:html_id].present?

      ''
    end

    def html_classes
      return list.html_classes unless opts[:html_classes].present?

      "#{list.html_classes} #{opts[:html_classes]}"
    end
  end
end
