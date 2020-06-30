require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "integral"

module Dummy
  class Application < Rails::Application
    config.active_record.sqlite3.represent_boolean_as_integer = true

    config.action_mailer.default_url_options = { :host => "test.somehost.com" }
    Rails.application.routes.default_url_options[:host] = 'test.somehost.com'
  end
end
