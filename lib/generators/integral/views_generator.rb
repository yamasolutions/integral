module Integral
  # Integral Generators
  module Generators
    # Generates a copy of Integral views
    #
    # @example Generate all Integral views
    #   rails g integral:views --views 'backend frontend devise mailer'
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../../app/views', __FILE__)
      class_option :views, aliases: '-v', type: :array, default: 'frontend'
      desc 'Copies Integral views to your application'

      # Copies over backend views
      def copy_backend_views
        return unless options['views'].include?('backend')

        directory 'integral/backend'
        directory 'layouts/integral/backend'
        file 'layouts/integral/backend.html.haml'
      end

      # Copies over frontend views
      def copy_frontend_views
        return unless options['views'].include?('frontend')

        directory 'integral/pages'
        directory 'integral/posts'
        directory 'integral/tags'
        directory 'integral/shared'
        directory 'layouts/integral/frontend'
        file 'layouts/integral/frontend.html.haml'
      end

      # Copies over mailer views
      def copy_mailer_views
        return unless options['views'].include?('mailer')

        directory 'integral/contact_mailer'
        directory 'layouts/integral/mailer'
        file 'layouts/integral/mailer.html.inky-haml'
      end

      # Copies over devise views
      def copy_devise_views
        return unless options['views'].include?('devise')

        directory 'devise'
        file 'layouts/integral/login.haml'
      end

      private

      def directory(source, destination = nil)
        destination = "app/views/#{source}" if destination.nil?

        super(source, destination)
      end

      def file(source, destination = nil)
        destination = "app/views/#{source}" if destination.nil?

        copy_file(source, destination)
      end
    end
  end
end
