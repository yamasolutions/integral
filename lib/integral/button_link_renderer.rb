module Integral
  # Foundation pagination with buttons
  class ButtonLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer
    # The URL or page
    def url(page)
      page
    end

    # Link item
    def link(text, target, attributes = {})
      attributes['data-page'] = target if target.is_a?(Integer)
      tag(:button, text, attributes)
    end

    # Pagination container
    def to_html
      list_items = pagination.map do |item|
        item.is_a?(Integer) ? page_number(item) : send(item)
      end.join(@options[:link_separator])

      tag(:ul, list_items, class: "pagination #{@options[:class]}")
    end

    # Container attributes
    def container_attributes
      super.except(:link_options)
    end

    protected

    def page_number(page)
      link_options = @options[:link_options] || {}

      if page == current_page
        tag :li, tag(:span, page), class: 'current'
      else
        tag :li, link(page, page, link_options.merge(rel: rel_value(page)))
      end
    end

    def previous_or_next_page(page, text, classname)
      link_options = @options[:link_options] || {}
      if page
        tag :li, link(text, page, link_options), class: classname
      else
        tag :li, tag(:span, text), class: format('%s disabled', classname)
      end
    end

    # def gap
    #   tag :li, '', class: 'ellipsis'
    # end
  end
end
