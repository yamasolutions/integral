module Integral
  # Integral Middleware
  module Middleware
    # Handles dynamic page routing.
    # Checks all GET requests to see if the PATH matches an Integral::Page path
    # If a match is found the PATH is rewritten from human readable into something Rails
    # router understands. i.e. '/company/who-we-are' -> /pages/12
    class PageRouter
      def initialize(app)
        @app = app
      end

      # Handles dynamic Integral::Page routing.
      def call(env)
        request = Rack::Request.new(env)

        # Return early if request is not a GET
        return @app.call(env) unless request.get?

        # Return early if request is within backend area
        backend_path = "/#{Integral.backend_namespace}/"
        return @app.call(env) if request.path_info.starts_with?(backend_path)

        # Rewrites path if the request linked to an Integral::Page
        rewrite_path(env, request.path_info)

        @app.call(env)
      end

      private

      # Checks to see if path is linked to a page
      # TODO: Rather than hitting the DB on each request here a Redis solution could be implemented
      #
      # @param path [String] Path the request is linked to
      #
      # @return [Integer] ID of the Integral::Page the path is linked to
      def page_identifier(path)
        return dynamic_homepage if path == '/' && Integral.dynamic_homepage_enabled?

        # TODO: Speed this up by adding an index & unique constraint on path attribute
        Integral::Page.not_archived.find_by_path(path)&.id
      end

      def category_identifier(path)
        return nil unless path.starts_with?("/#{Integral.blog_namespace}")

        Integral::Category.select(:id, :slug).all.map { |category| [category.id, "/#{Integral.blog_namespace}/#{category.slug}"] }.find { |category| category[1] == path }&.first
      end

      # Converts the request path from human readable into something Rails router understands
      # i.e. '/company/who-we-are' -> /pages/12
      #
      # @param env [Hash] Environment of the request
      # @param path [String] Path the request is linked to
      #
      # @return [String] Path Rails needs to link the request to the correct Integral::Page record
      def rewrite_path(env, path)
        page_id = page_identifier(path)
        if page_id
          env['PATH_INFO'] = "/pages/#{page_id}"
        else
          category_id = category_identifier(path)

          env['PATH_INFO'] = "/#{Integral.blog_namespace}/categories/#{category_id}" if category_id
        end
      rescue StandardError => e
        handle_rewrite_error(e)
      end

      # Homepage ID as defined by User within backend settings
      # Possibly should add a fallback to return Page.first if settings is available
      #
      # @return [String] Homepage ID
      def dynamic_homepage
        page_id = Integral::Settings['homepage_id']
        handle_nil_homepage if page_id.nil?

        page_id
      end

      # Handles if an error occurs when rewriting path
      def handle_rewrite_error(error)
        Rails.logger.debug("IntegralMessage: #{error}")
      end

      # Handles if Dynamic Homepage is enabled & ID is not set
      def handle_nil_homepage
        Rails.logger.debug('IntegralMessage: Dynamic Homepage is nil. Set within Backend Settings.')
      end
    end
  end
end
