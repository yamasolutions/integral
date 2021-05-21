# ActiveSupport.on_load :action_view do
#   module Integral
#     class BootstrapPaginationRenderer < WillPaginate::ActionView::LinkRenderer
#       # Pagination container
#       def to_html
#         list_items = pagination.map do |item|
#           item.is_a?(Integer) ? page_number(item) : send(item)
#         end.join(@options[:link_separator])
#
#         tag(:ul, list_items, class: "pagination #{@options[:class]}")
#       end
#
#       # Container attributes
#       def container_attributes
#         super.except(:link_options)
#       end
#
#       protected
#
#       def page_number(page)
#         link_options = @options[:link_options] || {}
#
#         if page == current_page
#           tag :li, tag(:span, page, class: 'page-link'), class: 'page-item active'
#         else
#           tag :li, link(page, page, link_options.merge(rel: rel_value(page), class: 'page-link')), class: 'page-item'
#         end
#       end
#
#       def previous_or_next_page(page, text, classname)
#         link_options = @options[:link_options] || {}
#         if page
#           tag :li, link(text, page, link_options.merge(class: 'page-link')), class: classname
#         else
#           tag :li, tag(:span, text, class: 'page-link'), class: format('%s page-item disabled', classname)
#         end
#       end
#     end
#   end
# end
#
