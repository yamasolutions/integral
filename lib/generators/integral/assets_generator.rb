module Integral
  # Integral Generators
  module Generators
    # Generates a copy of Integral assets
    #
    # @example Generate all Integral assets
    #   rails g integral:assets --assets 'backend frontend email'
    class AssetsGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../app/assets', __dir__)
      class_option :asset_list, aliases: '-a', type: :array, default: 'frontend'
      desc 'Copies Integral assets to your application'

      # Copies over backend assets
      def copy_backend_assets
        return unless options['asset_list'].include?('backend')

        file 'javascripts/integral/backend.js'
        file 'stylesheets/integral/backend.sass'
        directory 'stylesheets/integral/backend'
      end

      # Copies over frontend assets
      def copy_frontend_assets
        return unless options['asset_list'].include?('frontend')

        file 'javascripts/integral/frontend.js'
        file 'stylesheets/integral/frontend.scss'
        directory 'stylesheets/integral/frontend'
      end

      # Copies over mailer assets
      def copy_mailer_assets
        return unless options['asset_list'].include?('email')

        file 'stylesheets/integral/emails.scss'
        directory 'stylesheets/integral/emails'
      end

      private

      def directory(source, destination = nil)
        destination = "app/assets/#{source}" if destination.nil?

        super(source, destination)
      end

      def file(source, destination = nil)
        destination = "app/assets/#{source}" if destination.nil?

        copy_file(source, destination)
      end
    end
  end
end
