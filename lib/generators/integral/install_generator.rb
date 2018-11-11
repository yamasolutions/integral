module Integral
  # Integral Generators
  module Generators
    # Generates helpful Integral initializers
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      desc 'Creates Integral, Carrierwave, CarrierwaveBackgrounder & Sitemap initializers'

      # Copies over necessary initialiser files
      def copy_initializer_files
        copy_file 'integral.rb', 'config/initializers/integral.rb'
        copy_file 'app.yml', 'config/app.yml'
        copy_file 'carrierwave.rb', 'config/initializers/carrierwave.rb'
        copy_file 'carrierwave_backgrounder.rb', 'config/initializers/carrierwave_backgrounder.rb'
        copy_file 'sitemap.rb', 'config/sitemap.rb'
      end

      # Copies routes file
      def copy_routes
        copy_file 'routes.rb', 'config/routes.rb'
      end

      # Copies seeding file
      def copy_seeding
        copy_file 'seeds.rb', 'db/seeds.rb'
      end

      # Copy required migrations
      def copy_migrations
        rake 'integral:install:migrations'
      end

      # Create, migrate and run setup on database - setup is incase DB was already present
      def setup_database
        rake 'db:create'
        rake 'db:migrate'
        rake 'db:setup'
      end

      # Output successful install message
      def install_message
        puts ' --------------------------------------------------------------------'
        puts '  Integral has successfully installed! '
        puts
        puts "  The admin backend is located at /#{Integral.backend_namespace}."
        puts
        puts "  User email     :  #{Integral::User.first.email}"
        puts '  User password     :  password'
        puts ' --------------------------------------------------------------------'
      end
    end
  end
end
