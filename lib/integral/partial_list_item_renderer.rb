module Integral
  # Allow list items to be renderered through a partial
  class PartialListItemRenderer < Integral::ListItemRenderer
    def initialize(list_item, opts = {})
      super

      raise_if_partial_path_missing
    end

    # Override Integral::ListItemRenderer#render_item
    def render_item
      partial_opts = {
        title: title,
        subtitle: subtitle,
        description: description,
        url: url,
        image: image,
        type: list_item.type,
        object: object_available? ? list_item.object.decorate : nil,
        renderer: self
      }

      controller.render partial: @opts[:partial_path], locals: partial_opts, layout: false
    end

    private

    def raise_if_partial_path_missing
      return if @opts[:partial_path].present?

      error_msg = 'PartialListItemRenderer requires the partial_path (pass this in via opts hash)'
      raise ArgumentError, error_msg
    end

    def controller
      return @opts[:controller] if @opts[:controller].present?

      ApplicationController
    end
  end
end
