namespace :integral do
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
