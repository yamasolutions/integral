module Integral
  # Handles safely rendering list items
  class ListItemRenderer
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Context

    attr_accessor :list_item, :opts

    # Renders the provided list item with options given
    #
    # @return [String] the rendered list item
    def self.render(list_item, opts = {})
      renderer = new(list_item, opts)
      renderer.render
    end

    # @param list_item [ListItem] object to render
    # @param opts [Hash] options hash
    def initialize(list_item, opts = {})
      @opts = opts.reverse_merge(
        wrapper_element: 'li',
        child_wrapper_element: 'ul',
        child_wrapper_class: ''
      )

      @list_item = list_item
    end

    # Renders the provided list_item
    #
    # @return [String] the rendered list item (including possible children)
    def render
      return render_no_object_warning if list_item.object? && !object_available?

      if list_item.has_children?
        content_tag opts[:wrapper_element], class: html_classes do
          concat render_item
          concat content_tag opts[:child_wrapper_element], render_children, { class: opts[:child_wrapper_class] }, false
        end
      else
        if opts[:wrapper_element]
          content_tag opts[:wrapper_element], class: html_classes do
            render_item
          end
        else
          render_item
        end
      end
    end

    # @return [String] list item HTML
    def render_item
      content_tag :a, title, item_options
    end

    # @return [Hash] list item options
    def item_options
      opts = {}
      opts[:class] = 'dropdown-button' if list_item.has_children?
      opts[:href] = url if url.present?
      opts[:target] = target if target.present? && target != '_self'

      opts
    end

    # Loop over all list item children calling render on each
    #
    # @return [String] compiled string of all the rendered list item children
    def render_children
      children = ''

      list_item.children.each do |child|
        children += self.class.render(child, opts)
      end

      children
    end

    # Used within backend for preselecting type in dropdown
    # TODO: Move this onto the model level
    def type_for_dropdown
      return list_item.type unless list_item.object?

      list_item.object_type.to_s
    end

    # @return [String] title of list item
    def title
      provide_attr(:title)
    end

    # @return [String] description of list item
    def description
      provide_attr(:description)
    end

    # @return [String] target of list item
    def target
      list_item.target unless list_item.basic?
    end

    # @return [String] URL of list item
    def url
      return if list_item.basic?

      url = provide_attr(:url)

      return url if url.nil? || url.empty?
      return CGI.unescape(url) if url.match?(URI::DEFAULT_PARSER.make_regexp)

      CGI.unescape("#{Rails.application.routes.default_url_options[:host]}#{url}")
    end

    # @return [String] subtitle of list item
    def subtitle
      provide_attr(:subtitle)
    end

    # Returns the non object image path
    def object_image_url(size: :medium)
      image = object_data[:image] if object_available?

      if image.respond_to?(:attached?) && image.attached?
        url_helpers.url_for(image.representation(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[size])))
      elsif image.present?
        image
      else
        fallback_image_url
      end
    end

    def non_object_image
      list_item.image if list_item.image.present? && list_item.image.attached?
    end

    # Returns the non object image path
    def non_object_image_url(size: :medium)
      if non_object_image.present?
        url_helpers.url_for(non_object_image.representation(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[size])))
      else
        fallback_image_url
      end
    end

    def image
      if list_item.image.present?
        return list_item.image
      elsif object_available? && object_data[:image].present?
        object_data[:image]
      end
    end

    def image_url(size: :medium, fallback: true)
      if image.present?
        if size == :original
          url_helpers.url_for(image.attachment)
        else
          url_helpers.url_for(image.representation(Integral.image_transformation_options.merge!(resize_to_limit: Integral.image_sizes[size])))
        end
      else
        fallback_image_url if fallback
      end
    end

    # @return [Boolean] whether or not title is a required attribute
    # TODO: This and other methods which are only used in backend could be moved to decorators
    def title_required?
      !list_item.object?
    end

    # @return [String] path to fallback image for list items
    def fallback_image_url
      ActionController::Base.helpers.image_path('integral/defaults/no_image_available.jpg')
    end

    def object_data
      return nil unless object_available?

      @object_data ||= list_item.object.to_list_item
    end

    private

    def render_no_object_warning
      message = "Tried to render a list item (##{list_item.id}) with no object."
      Rails.logger.debug("IntegralMessage: #{message}")
      "<!-- Warning: #{message} -->"
    end

    # Works out what the provided attr evaluates to.
    #
    # @param attr [Symbol] attribute to evaluate
    #
    # @return [String] value of attribute
    def provide_attr(attr)
      list_item_attr_value = list_item.public_send(attr)

      # Provide user supplied attr
      return list_item_attr_value if list_item_attr_value.present?

      # Provide object supplied attr
      return object_data[attr] if object_available?

      # Provide error - Object is linked but has been deleted
      return 'Object Unavailable' if list_item.object? && !object_available?

      # Provide empty string - no attr supplied and no object linked
      ''
    end

    def object_available?
      @object_available ||= list_item.object? && list_item.object.present?
    end

    def html_classes
      return list_item.html_classes unless opts[:html_classes].present?

      "#{list_item.html_classes} #{opts[:html_classes]}"
    end

    def url_helpers
      Rails.application.routes.url_helpers
    end
  end
end
