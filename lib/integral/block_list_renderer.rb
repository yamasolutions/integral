module Integral
  # Handles the rendering of dynamic blocks such as recent posts
  class BlockListRenderer
    # Renders dynamic blocks within the HTML snippet then strips all HTML comments (including Gutenberg markup)
    #
    # @param raw_html [String]
    #
    # @return [String] Parsed content
    def self.render(raw_html)
      html = Nokogiri::HTML(raw_html)

      # Find & render all instances of a dynamic block
      Integral.dynamic_blocks.each do |dynamic_block|
        html.xpath('//comment()').select {|comment| comment.inner_text.starts_with?(" wp:#{dynamic_block.name}") }.each do |block_instance|
          block_attributes = block_instance.inner_text.split(" wp:#{dynamic_block.name}")[1][0...-1]
          block_attributes = block_attributes.blank? ? {} : JSON.parse(block_attributes)
          block_instance.replace(render_block(dynamic_block, block_attributes))
        end
      end

      html.xpath('//comment()').remove
      html.css('body').inner_html.html_safe
    end

    # Renders a specific block using the provided options
    #
    # @param block [String] name of block
    # @param options [Hash] block options to use when rendering
    #
    # @return [String] block content (HTML)
    def self.render_block(block, options)
      block.render(options)
    rescue StandardError => e
      respond_with_block_error(e)
    end

    # Handles block errors
    def self.respond_with_block_error(error)
      Rails.logger.error("Error rendering block - #{error.message}")
      ''
    end
  end
end
