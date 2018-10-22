module Integral
  # Mail helper
  module MailHelper
    # @return [String] <a> tag containing URL of website and hostname as label
    def website_url
      full_url = Rails.application.routes.default_url_options[:host]
      hostname = Addressable::URI.parse(full_url).host
      link_to hostname, full_url
    end

    # @return [String] html tag containing title. Could override this to instead render an image.
    def title
      content_tag :h1, Integral::Settings.website_title
    end
  end
end
