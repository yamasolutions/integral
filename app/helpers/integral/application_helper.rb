module Integral
  # Base Frontend Helper
  module ApplicationHelper
    include Integral::SupportHelper
    include Integral::SocialHelper
    include Integral::BlogHelper
    include Integral::GalleryHelper

    # @return [String] Javascript snippet containing LD-JSON
    def render_json_ld
      content_tag 'script', type: 'application/ld+json' do
        yield.to_json.html_safe
      end
    end

    # @param [String] content HTML, most likely generated from the WYSIWYG editor
    #
    # @return [String] Processed HTML. Any Integral Widgets placeholders replaced with content.
    def render_content(content)
      Integral::ContentRenderer.render(content)
    end

    # @param [Integral::List] list the list to render
    # @param [Hash] opts the options to render list
    # @option opts [String] :html_classes the html classes for the list
    # @option opts [String] :data_attributes the html data attributes for the list
    # @option opts [Hash] :item_renderer_opts the hash of options for list items
    #
    # @return [String] HTML generated by rendering list
    def render_list(list, opts = {})
      opts.reverse_merge!(
        renderer: Integral::ListRenderer
      )

      opts[:renderer].render(list, opts).html_safe
    end

    # @return [Integal::List] main menu list as defined in settings area
    def main_menu_list
      id = Integral::Settings.send('main_menu_list_id')
      @main_menu_list ||= Integral::List.find_by_id(id)
    end

    def render_breadcrumbs?
      true
    end

    # Frontend Google Tag Manager Snippet
    # @return [String] GTM Container if ID has been supplied
    def google_tag_manager(type = :script)
      GoogleTagManager.render(Settings.google_tag_manager_id, type)
    end

    # @return [String] Configurable Website title
    def site_title
      Settings.website_title
    end
  end
end