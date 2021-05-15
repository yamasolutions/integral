require 'devise'
require 'devise_invitable'

require 'integral/version'
require 'integral/router'
require 'integral/middleware/alias_router'
require 'integral/engine'
require 'integral/google_tag_manager'
require 'integral/grids/activities_grid'
require 'integral/grids/block_lists_grid'
require 'integral/grids/pages_grid'
require 'integral/grids/users_grid'
require 'integral/grids/lists_grid'
require 'integral/grids/posts_grid'
require 'integral/grids/files_grid'
require 'integral/acts_as_listable'
require 'integral/acts_as_integral'
require 'integral/list_renderer'
require 'integral/swiper_list_renderer'
require 'integral/list_item_renderer'
require 'integral/partial_list_item_renderer'
require 'integral/chart_renderer/base'
require 'integral/chart_renderer/donut'
require 'integral/chart_renderer/line'

# Integral
module Integral
  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class << self
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end
  end

  # Enables engine configuration
  def self.configure
    yield(self)
  end

  mattr_accessor :backend_namespace
  @@backend_namespace = 'admin'

  mattr_accessor :backend_locales
  @@backend_locales = [:en]

  mattr_accessor :frontend_locales
  @@frontend_locales = [:en]

  mattr_accessor :additional_settings_params
  @@additional_settings_params = []

  mattr_accessor :additional_post_params
  @@additional_post_params = []

  mattr_accessor :additional_page_params
  @@additional_page_params = []

  mattr_accessor :gtm_container_id
  @@gtm_container_id = ''

  mattr_accessor :blog_enabled
  @@blog_enabled = true

  mattr_accessor :blog_namespace
  @@blog_namespace = 'blog'

  mattr_accessor :black_listed_paths
  @@black_listed_paths = ['/admin']

  mattr_accessor :root_path
  @@root_path = nil

  mattr_accessor :frontend_parent_controller
  @@frontend_parent_controller = 'Integral::ApplicationController'

  mattr_accessor :image_sizes
  @@image_sizes = {
    thumbnail: [50, 50],
    small: [500, 500],
    medium: [800, 800],
    large: [1600, 1600]
  }

  mattr_accessor :additional_page_templates
  @@additional_page_templates = []

  mattr_accessor :compression_enabled
  @@compression_enabled = true

  mattr_accessor :image_compression_quality
  @@image_compression_quality = 85

  mattr_accessor :editable_persisted_images
  @@editable_persisted_images = false

  mattr_accessor :description_length_maximum
  @@description_length_maximum = 300

  mattr_accessor :description_length_minimum
  @@description_length_minimum = 50

  mattr_accessor :title_length_maximum
  @@title_length_maximum = 60

  mattr_accessor :title_length_minimum
  @@title_length_minimum = 4

  mattr_accessor :accepted_file_types
  @@accepted_file_types = ['application/pdf', 'image/*', 'video/*']

  mattr_accessor :maximum_file_size
  @@maximum_file_size = 104857600 # 100MB

  # @return [Boolean] Whether or not the frontend is multilingual
  def self.multilingual_frontend?
    Integral.frontend_locales.count > 1
  end

  # @return [Boolean] Shortcut to find out if blog is enabled
  def self.blog_enabled?
    Integral.blog_enabled == true
  end

  # @return [Boolean] Compression status
  def self.compression_enabled?
    Integral.compression_enabled == true
  end

  # @return [Boolean] Enables Dynamic Routing of the homepage using Integral::Middleware::Router
  def self.dynamic_homepage_enabled?
    Integral.root_path.nil?
  end
end
