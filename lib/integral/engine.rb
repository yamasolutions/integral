module Integral
  # Integral Engine
  class Engine < ::Rails::Engine
    require 'haml'
    require 'htmlcompressor'
    require 'groupdate'
    require 'turbolinks'
    require 'toastr-rails'
    require 'nprogress-rails'
    require 'simple_form'
    require 'gibbon'
    require 'cocoon'
    require 'draper'
    require 'coffee-rails'
    require 'jquery-rails'
    require 'rails-ujs'
    require 'client_side_validations'
    require 'client_side_validations/simple_form'
    require 'parsley-rails'
    require 'datagrid'
    require 'font-awesome-sass'
    require 'breadcrumbs_on_rails'
    require 'foundation-rails'
    require 'pundit'
    require 'carrierwave'
    require 'carrierwave-aws'
    require 'carrierwave_backgrounder'
    require 'carrierwave-imageoptimizer'
    require 'ckeditor'
    require 'paper_trail'
    require 'diffy'
    require 'active_record_union'
    require 'i18n-js'
    require 'meta-tags'
    require 'sitemap_generator'
    # require 'before_render'
    require 'friendly_id'
    require 'acts-as-taggable-on'
    require 'paranoia'
    require 'inky'
    require 'premailer/rails'
    require 'will_paginate'
    require 'will_paginate-foundation'
    require 'rails-settings-cached'
    require 'gaffe'
    require 'fast_jsonapi'
    require 'route_translator'
    require 'webpacker'

    isolate_namespace Integral

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Dynamic page routing
    config.middleware.use Integral::Middleware::PageRouter

    # Engine customization
    config.to_prepare do
      # Allow Integral to be extended
      Dir.glob(Rails.root + 'app/extensions/**/*_decorator*.rb').each do |c|
        require_dependency(c)
      end

      Integral::Engine.routes.default_url_options[:host] = Rails.application.routes.default_url_options[:host]

      if Integral.multilingual_frontend?
        RouteTranslator.config do |config|
          config.available_locales = Integral.frontend_locales
          config.generate_unnamed_unlocalized_routes = true
        end
      end
    end

    # Menu Initializaion - Add items to menus which are not directly linked to a Modal
    initializer "integral.backend.set_main_menu_items" do |app|
      ActiveSupport::Notifications.subscribe 'integral.routes_loaded' do
        Integral::ActsAsIntegral.add_backend_main_menu_item(id: :home, icon: 'home', order: 10, label: 'Home', url: Integral::Engine.routes.url_helpers.backend_dashboard_url)
        Integral::ActsAsIntegral.add_backend_main_menu_item(id: :activities, icon: 'crosshairs', order: 90, label: 'Activities', url: Integral::Engine.routes.url_helpers.backend_activities_url, authorize: proc { policy(Integral::Version).manager? })
        Integral::ActsAsIntegral.add_backend_main_menu_item(id: :settings, icon: 'cog', order: 100, label: 'Settings', url: Integral::Engine.routes.url_helpers.backend_settings_url, authorize: proc { current_user.admin? })
      end
    end

    # Clientside I18n
    config.assets.initialize_on_precompile = true

    # Do not automatically include all helpers
    config.action_controller.include_all_helpers = false

    # Allows engine factories to be reused by application
    initializer 'model_core.factories', after: 'factory_bot.set_factory_paths' do
      if defined?(FactoryBot)
        FactoryBot.definition_file_paths << File.expand_path('../../spec/factories', __dir__)
      end
    end

    initializer 'integral.assets.precompile' do |app|
      assets_for_precompile = [
        # Dashboard tiles
        'integral/tiles/*',
        # Defaults
        'integral/defaults/*',
        # CKEditor Overrides
        'ckeditor/my_contents.css',
        'ckeditor/my_styles.js',
        'ckeditor/my_config.js',
        'ckeditor/filebrowser/*',
        'ckeditor/skins/*',
        'ckeditor/lang/*',
        'ckeditor/plugins/*',

        # Frontend
        'integral/frontend.js',
        'integral/frontend.css',
        'integral/posts-hero-banner.jpg',
        'integral/demo/*',
        'logo.png',

        # Backend
        'integral/backend.js',
        'integral/backend.css',
        'integral/backend/logo.png',
        'integral/backend/data-unavailable.png',
        'integral/image-not-set.png',

        # Block Editor
        'integral/block_editor.css',

        # Emails
        'integral/emails.css',
        'integral/emails/colors.css',

        # Errors
        'errors.css'
      ]

      app.config.assets.precompile.concat assets_for_precompile
    end

    initializer "webpacker.proxy" do |app|
      insert_middleware = begin
                            Integral.webpacker.config.dev_server.present?
                          rescue
                            nil
                          end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy,
        ssl_verify_none: true,
        webpacker: Integral.webpacker
      )
    end

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end
  end
end
