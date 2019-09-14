require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "integral"

module Dummy
  class Application < Rails::Application
    config.action_dispatch.return_only_media_type_on_content_type = false
  end
end
