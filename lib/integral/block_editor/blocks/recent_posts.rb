module Integral
  module BlockEditor
    # Blocks used to render dynamic content
    module Blocks
      # Outputs recent posts
      class RecentPosts
        def self.name
          'integral/recent-posts'
        end

        # Render the recent posts
        def self.render(options = {})
          options = options.reverse_merge(default_options.with_indifferent_access)

          controller.render(
            partial: 'integral/blocks/recent-posts/block',
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
            tags: '',
            categories: '',
            limit: 3
          }
        end

        # Scope of the block
        def self.skope(options)
          skope = Integral::Post.published.order(published_at: :desc).where(locale: I18n.locale)
          skope = skope.tagged_with(options[:tags].split(','), any: true) if options[:tags].present?
          if options[:categories].present?
            category_ids = Integral::Category.where(slug: options[:categories].split(',')).pluck(:id)
            skope = skope.where(category_id: category_ids)
          end
          skope.limit(options[:limit])
        end
      end
    end
  end
end
