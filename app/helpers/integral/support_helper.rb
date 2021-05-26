module Integral
  # Support Helper which contains common helper methods used within backend & frontend
  module SupportHelper
    def icon(name)
      content_tag(:i, nil, class: name)
    end

    # @return [Boolean] Whether or not to display media query indicator
    # Green - large screens, medium - tablets, red - mobile
    def display_media_query_indicator?
      Rails.env.development?
    end

    # Creates an anchor link
    #
    # @param body [String] body of the link
    # @param location [String] location of the anchor
    #
    # @return [String] anchor to a particular location of the current page
    def anchor_to(body, location)
      current_path = url_for(only_path: false)
      path = "#{current_path}##{location}"

      link_to body, path
    end

    # Override method_missing to check for main app routes before throwing exception
    def method_missing(method, *args, &block)
      if method.to_s.end_with?('_path', '_url')
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    # Override respond_to? to check for main app routes
    def respond_to?(method, include_all = false)
      if method.to_s.end_with?('_path', '_url')
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end
  end
end
