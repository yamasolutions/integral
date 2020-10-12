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

        # Rewrites path if the request linked to an Integral::Page or Integral::Category
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
        # TODO: Speed this up by adding an index & unique constraint on path attribute
        Integral::Page.not_archived.find_by_path(path)&.id
      end

      def category_identifier(path, locale)
        slug = path.split('/').last

        if locale
          return nil unless path.starts_with?("/#{locale}/#{Integral.blog_namespace}")
        else
          return nil unless path.starts_with?("/#{Integral.blog_namespace}")

          locale = Integral.frontend_locales.first
        end

        Integral::Category.where(locale: locale, slug: slug).first&.id
      end

      # Converts the request path from human readable into something Rails router understands
      # i.e. '/company/who-we-are' -> /pages/12
      #
      # @param env [Hash] Environment of the request
      # @param path [String] Path the request is linked to
      #
      # @return [String] Path Rails needs to link the request to the correct Integral::Page record
      def rewrite_path(env, path)
        locale = Integral.frontend_locales.find { |locale| path.starts_with?("/#{locale}/") || path == "/#{locale}" } || Integral.frontend_locales.first if Integral.multilingual_frontend?

        page_id = page_identifier(path)
        if page_id
          env['PATH_INFO'] = localized_path("/pages/#{page_id}", locale)
        else
          category_id = category_identifier(path, locale)

          env['PATH_INFO'] = localized_path("/#{Integral.blog_namespace}/categories/#{category_id}", locale) if category_id
        end
      rescue StandardError => e
        handle_rewrite_error(e)
      end

      def localized_path(path, locale)
        locale ? "/#{locale}#{path}" : path
      end

      # Handles if an error occurs when rewriting path
      def handle_rewrite_error(error)
        Rails.logger.debug("IntegralMessage: #{error}")
      end
    end
  end
end
