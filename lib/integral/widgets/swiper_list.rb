module Integral
  # Widgets used to generate dynamic content
  module Widgets
    # Outputs swiper lists
    #
    # Example Widget Markup
    # <p class='integral-widget' data-widget-type='swiper_list' data-widget-value-list_id='1337' data-widget-value-slide_view_path='shared/my_swiper_slide'>
    class SwiperList
      # Render a swiper list
      def self.render(options = {})
        options = options.reverse_merge(default_options)

        list_id = options[:list_id]
        raise ArgumentError, 'list_id must be provided as a widget value' unless list_id.present?

        list = Integral::List.find_by_id(list_id)
        # TODO: Move most of these options up to SwiperListRenderer as defaults (?)
        list_opts = {
          item_renderer: Integral::PartialListItemRenderer,
          html_classes: options[:html_classes],
          item_renderer_opts: {
            partial_path: options[:slide_view_path],
            wrapper_element: 'div',
            html_classes: 'swiper-slide',
            image_version: :small
          }
        }

        Integral::SwiperListRenderer.render(list, list_opts)
      end

      # Default widget options
      def self.default_options
        {
          slide_view_path: 'integral/shared/record_card',
          html_classes: ''
        }
      end
    end
  end
end
