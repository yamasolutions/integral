# Adds lazy content behaviour to a model
module Integral
  # Enable lazy loading WYSIWYG content
  module LazyContentable
    extend ActiveSupport::Concern

    # TODO: Re-add this (?) - It's removing the block comment markup
    # included do
    #   before_save :lazyload_content
    # end

    # @return [String] body HTML ready for WYSIWYG editor
    def editor_body
      html = Nokogiri::HTML(body)

      # Remove image lazyloading
      html.css('img.lazyload').each do |element|
        element.attributes['src'].value = element.attributes['data-src'].value
      end

      html.css('body').inner_html
    end

    private

    def lazyload_content
      html = Nokogiri::HTML(body)

      # Add lazyloading to tagged images
      html.css('img.lazyload').each do |element|
        element['data-src'] = element.attributes['src'].value
        element.attributes['src'].value = ''
      end

      # Add lazy loading to oEmbeds
      html.css('div[data-oembed-url]').each do |element|
        next if element.css('blockquote.lazyload').any?

        blockquote = element.css('blockquote').first

        next unless blockquote.present?

        blockquote['class'] = "#{blockquote.attributes['class']} lazyload"

        if element['data-oembed-url'].starts_with?('https://www.instagram.com')
          blockquote['data-instagram'] = 'instagram'
        elsif element['data-oembed-url'].starts_with?('https://twitter.com')
          blockquote['data-twitter'] = 'twitter'
        end
      end

      self.body = html.css('body').inner_html
    end
  end
end
