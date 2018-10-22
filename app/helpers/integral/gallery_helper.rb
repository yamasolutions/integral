module Integral
  # Gallery Helper which contains methods used to help render image galleries
  module GalleryHelper
    # Renders a thumbnail gallery
    def render_thumb_gallery(list, opts = {})
      opts.reverse_merge!(
        renderer: Integral::SwiperListRenderer,
        item_renderer: Integral::PartialListItemRenderer,
        item_renderer_opts: {
          partial_path: 'integral/shared/gallery/thumb_slide',
          wrapper_element: 'div',
          image_version: :small,
          html_classes: 'swiper-slide'
        }
      )

      opts[:renderer].render(list, opts).html_safe
    end

    # Renders an image gallery using the provided list
    def render_gallery(list, opts = {})
      opts.reverse_merge!(
        renderer: Integral::SwiperListRenderer,
        item_renderer: Integral::PartialListItemRenderer,
        item_renderer_opts: {
          partial_path: 'integral/shared/gallery/slide',
          wrapper_element: 'div',
          image_version: :large,
          html_classes: 'swiper-slide'
        }
      )

      opts[:renderer].render(list, opts).html_safe
    end
  end
end
