def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new(STDOUT)
  yield
ensure
  Webpacker.logger = old_logger
end

namespace :integral do
  namespace :webpacker do
    desc "Install deps with yarn"
    task :yarn_install do
      Dir.chdir(File.join(__dir__, "../..")) do
        system "yarn install --no-progress --production"
      end
    end

    desc "Compile JavaScript packs using webpack for production with digests"
    task compile: [:yarn_install, :environment] do
      Webpacker.with_node_env("production") do
        ensure_log_goes_to_stdout do
          if Integral.webpacker.commands.compile
            # Successful compilation!
          else
            # Failed compilation
            exit!
          end
        end
      end
    end
  end


  # Generates pages used for demos and testing
  #
  # Usage: be rake integral:generate_pages[100] - Generates 100 pages
  #
  desc 'Generates Page objects used for demos and testing'
  task :generate_pages, [:amount] => [:environment] do |_t, args|
    amount_of_pages = args[:amount].to_i
    amount_of_pages = 10 if amount_of_pages.zero?

    puts "Generating #{amount_of_pages} sample pages.."

    amount_of_pages.times do
      FactoryBot.create(:integral_page)
    end

    puts 'Complete.'
  end

  # Generates posts used for demos and testing
  #
  # Usage: be rake integral:generate_posts[100] - Generates 100 posts
  #
  desc 'Generates Post objects used for demos and testing'
  task :generate_posts, [:amount] => [:environment] do |_t, args|
    amount_of_posts = args[:amount].to_i
    amount_of_posts = 10 if amount_of_posts.zero?

    puts "Generating #{amount_of_posts} sample posts.."

    amount_of_posts.times do
      FactoryBot.create(:integral_post)
    end

    puts 'Complete.'
  end

  # Generates images used for demos and testing
  #
  # Usage: be rake integral:generate_images[100] - Generates 100 images taken from lorempixel
  #
  desc 'Generates Image objects used for demos and testing'
  task :generate_images, [:amount] => [:environment] do |_t, args|
    amount_of_posts = args[:amount].to_i
    amount_of_posts = 10 if amount_of_posts.zero?

    puts "Generating #{amount_of_posts} sample images.."

    amount_of_posts.times do
      image = FactoryBot.build(:image)
      image.remote_file_url = 'http://lorempixel.com/400/300'
      image.save
    end

    puts 'Complete.'
  end
end

def yarn_install_available?
  rails_major = Rails::VERSION::MAJOR
  rails_minor = Rails::VERSION::MINOR

  rails_major > 5 || (rails_major == 5 && rails_minor >= 1)
end

def enhance_assets_precompile
  # yarn:install was added in Rails 5.1
  deps = yarn_install_available? ? [] : ["integral:webpacker:yarn_install"]
  Rake::Task["assets:precompile"].enhance(deps) do
    Rake::Task["integral:webpacker:compile"].invoke
  end
end

# Compile packs after we've compiled all other assets during precompilation
skip_webpacker_precompile = %w(no false n f).include?(ENV["WEBPACKER_PRECOMPILE"])

unless skip_webpacker_precompile
  if Rake::Task.task_defined?("assets:precompile")
    enhance_assets_precompile
  else
    Rake::Task.define_task("assets:precompile" => "integral:webpacker:compile")
  end
end

