require 'devise'
require 'devise_invitable'

require 'integral/version'
require 'integral/router'
require 'integral/middleware/page_router'
require 'integral/engine'
require 'integral/slack_bot'
require 'integral/button_link_renderer'
require 'integral/google_tag_manager'
require 'integral/foundation_builder'
require 'integral/grids/activities_grid'
require 'integral/grids/pages_grid'
require 'integral/grids/users_grid'
require 'integral/grids/lists_grid'
require 'integral/grids/posts_grid'
require 'integral/grids/images_grid'
require 'integral/acts_as_listable'
require 'integral/widgets/recent_posts'
require 'integral/widgets/swiper_list'
require 'integral/content_renderer'
require 'integral/list_renderer'
require 'integral/swiper_list_renderer'
require 'integral/list_item_renderer'
require 'integral/partial_list_item_renderer'
require 'integral/chart_renderer/base'
require 'integral/chart_renderer/donut'
require 'integral/chart_renderer/line'

# Integral
module Integral
  # Enables engine configuration
  def self.configure
    yield(self)
  end

  mattr_accessor :backend_namespace
  @@backend_namespace = 'admin'

  mattr_accessor :backend_locales
  @@backend_locales = [:en]

  mattr_accessor :additional_settings_params
  @@additional_settings_params = []

  mattr_accessor :additional_widgets
  @@additional_widgets = []

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

  mattr_accessor :editor_image_size_limit
  @@editor_image_size_limit = [1600, 1600]

  mattr_accessor :image_thumbnail_size
  @@image_thumbnail_size = [50, 50]

  mattr_accessor :image_small_size
  @@image_small_size = [500, 500]

  mattr_accessor :image_medium_size
  @@image_medium_size = [800, 800]

  mattr_accessor :image_large_size
  @@image_large_size = [1600, 1600]

  mattr_accessor :additional_page_templates
  @@additional_page_templates = []

  mattr_accessor :compression_enabled
  @@compression_enabled = true

  mattr_accessor :image_compression_quality
  @@image_compression_quality = 85

  mattr_accessor :editable_persisted_images
  @@editable_persisted_images = false

  mattr_accessor :slack_web_hook_url
  @@slack_web_hook_url = nil

  mattr_accessor :description_length_maximum
  @@description_length_maximum = 300

  mattr_accessor :description_length_minimum
  @@description_length_minimum = 50

  mattr_accessor :title_length_maximum
  @@title_length_maximum = 60

  mattr_accessor :title_length_minimum
  @@title_length_minimum = 4

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
