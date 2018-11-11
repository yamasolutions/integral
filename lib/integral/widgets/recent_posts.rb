module Integral
  # Widgets used to generate dynamic content
  module Widgets
    # Outputs recent posts
    #
    # Example Widget Markup
    # <p class='integral-widget' data-widget-type='recent_posts' data-widget-value-tagged='awesome-tag'>
    class RecentPosts
      # Render the recent posts
      def self.render(options = {})
        options = options.reverse_merge(default_options)

        controller.render(
          partial: 'integral/posts/collection',
          locals: { collection: skope(options) },
          layout: false
        )
      end

      # Frontend controller used to render views
      def self.controller
        Integral.frontend_parent_controller.constantize
      end

      # Default widget options
      def self.default_options
        {
          amount: 2,
          tagged: ''
        }
      end

      # Scope of the widget
      def self.skope(options)
        skope = Integral::Post.published.order(published_at: :desc)
        skope = skope.tagged_with(options[:tagged].split) if options[:tagged].present?
        skope.limit(options[:amount])
      end
    end
  end
end
