$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'integral/version'

Gem::Specification.new do |s|
  s.name        = 'integral'
  s.version     = Integral::VERSION
  s.authors     = ['Patrick Lindsay']
  s.email       = ['patrick@yamasolutions.com']
  s.homepage    = 'https://github.com/yamasolutions/integral'
  s.summary     = 'Integral CMS combines all the tools necessary to create a website which stands up to the elements, whether you’re creating that niche blog you’ve always wanted or developing a complex application for a client.'
  s.description = "Building a professional website on Rails has never been easier. Create fascinating blog posts and interesting pages using Integrals sleek backend. Integrated SEO gives you full control of your online presence. There are no fancy over complicated methodologies to learn, so long as you have a basic grasp of Rails then you’ll be up and running in no time - with the ability to easily customise Integral to exactly what you want."
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md', 'spec/factories.rb', 'spec/support/image.jpg', 'public/**/*']

  s.add_dependency 'active_record_union', '~> 1.3.0' # Table Unions - Used joining Versioning tables
  s.add_dependency 'acts-as-taggable-on', '~> 7.0' # Tagging
  s.add_dependency 'breadcrumbs_on_rails', '~> 3.0' # Breadcrumbs
  s.add_dependency 'cocoon', '~> 1.2' # Nested forms
  s.add_dependency 'diffy', '~> 3.1' # View differences
  s.add_dependency 'gibbon', '~> 3.3' # Mailchimp API Wrapper
  s.add_dependency 'devise', '~> 4.8' # Authentication
  s.add_dependency 'devise_invitable', '~> 2.0' # Invitable authentication
  s.add_dependency 'draper', '~> 4.0' # Object decoration
  s.add_dependency 'friendly_id', '~> 5.2' # Slugging
  s.add_dependency "groupdate", "~> 3.0" # Group By
  s.add_dependency 'haml-rails', '~> 1.0' # HAML
  s.add_dependency 'htmlcompressor', '~> 0.2.0' # Compression
  s.add_dependency 'i18n-js', '~> 3.0.11' # Clientside translations
  s.add_dependency 'inky-rb' # , "~> 0.6" #  Responsive email-ready HTML helpers
  s.add_dependency 'meta-tags', '~> 2.4' # Meta Tag Management (SEO)
  s.add_dependency 'image_processing', '~> 1.12' # Image manipulation
  s.add_dependency 'paper_trail', '~> 11.0' # Audit trail
  s.add_dependency 'paranoia', '~> 2.0' # Soft-delete records
  s.add_dependency 'premailer-rails', '~> 1.11' # Stylesheet inlining for email
  s.add_dependency 'pundit', '~> 1.1' # Authorization
  s.add_dependency 'rails', '~> 6.1.1'
  s.add_dependency 'webpacker', '~> 5.1'
  s.add_dependency 'rails-settings-cached', '~> 0.6' # Persisted settings
  s.add_dependency 'sass-rails', '~> 6.0' # Sass
  s.add_dependency 'simple_form', '~> 5.0' # Form builder
  s.add_dependency 'sitemap_generator', '~> 6.0.1' # Sitemap Generator
  s.add_dependency 'turbo-rails', '~> 0.0'
  s.add_dependency 'datagrid', '~> 1.5.8' # Grids
  s.add_dependency 'will_paginate', '~> 3.1' # Pagination
  s.add_dependency 'fast_jsonapi', '~> 1.5' # Object Serialization
  s.add_dependency 'route_translator', '~> 8.0' # Multilingual routing
  s.add_dependency 'block_editor', '~> 0.1.0' # Block Editor

  s.add_development_dependency 'database_cleaner', '~> 1.5' # Manages database test states
  s.add_development_dependency 'factory_bot_rails', '~> 4.8' # Create reusable object templates
  s.add_development_dependency 'faker', '~> 2.18' # Random data generator
  s.add_development_dependency 'pry-rails', '~> 0.3' # Debugger
  s.add_development_dependency 'rails-controller-testing', '~> 1.0' # Rails controller testing
  s.add_development_dependency 'rspec-rails', '~> 4.0' # Testing framework
  s.add_development_dependency 'generator_spec', '~> 0.9' # Testing framework
  s.add_development_dependency 'shoulda-matchers', '~> 3.1' # Extra matchers for testing
  s.add_development_dependency 'pg', '~> 1.1' # Database

  s.add_development_dependency 'capybara', '~> 3.32' # Acceptance testing framework
  s.add_development_dependency 'launchy', '~> 2.4' # Automatically launch test pages
  s.add_development_dependency 'apparition', '~> 0.6.0' # Headless Capybara driver for JS
  s.add_development_dependency 'selenium-webdriver', '~> 3.142' # Headless Capybara driver for JS
  s.add_development_dependency 'rspec-retry', '~> 0.6.1' # Retry flaky specs

  # CI, code coverage, analysis and documentation tools
  s.add_development_dependency 'brakeman', '~> 3.4' # Static security
  s.add_development_dependency 'rubocop', '~> 0.52.1' # Ruby static code analyzer
  s.add_development_dependency 'ruby2ruby', '~> 2.2' # Ruby diff tool
  s.add_development_dependency 'simplecov', '~> 0.12' # Coverage
  s.add_development_dependency 'yard', '~> 0.9.11' # Documentation
end
