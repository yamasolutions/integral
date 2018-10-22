module Integral
  # Swiper list renderer - Renders list items within swiper container
  class SwiperListRenderer < Integral::ListRenderer
    # Override Integral::ListRenderer#render to wrap swiper-container around all rendered_items
    def render
      rendered_items = ''
      swiper_classes = 'swiper-container list-generated-swiper'
      list_items = list.list_items.to_a

      list_items.each do |list_item|
        rendered_items += render_item(list_item)
      end

      if opts[:html_classes].present?
        opts[:html_classes] += " #{swiper_classes}"
      else
        opts[:html_classes] = swiper_classes
      end

      rendered_items = [
        "<div class='swiper-wrapper'>#{rendered_items}</div>",
        "<div class='swiper-button-prev'></div>",
        "<div class='swiper-button-next'></div>",
        "<div class='swiper-pagination'></div>"
      ].join

      content_tag :div, rendered_items, html_options, false
    end
  end
end
