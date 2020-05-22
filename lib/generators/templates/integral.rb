# :nocov:
Integral.configure do |config|
  # Configure the parent controller which the blog and dynamic pages controller inherits from.
  # Default is 'Integral::ApplicationController'
  #
  # config.frontend_parent_controller = "::ApplicationController"

  # Configure the backend namespace.
  # Default is 'admin'
  #
  # config.backend_namespace = 'dashboard'

  # Set the backend Google Tag Manager Container (frontend is set through Settings UI).
  # Default is unset
  #
  # config.gtm_container_id = 'GTM-XXXXXXX'

  # Set the backend locales available to users
  # Default is [:en]
  #
  # config.backend_locales = [:en, :ja]

  # Set additional backend permitted setting params
  # Default is []
  #
  # config.additional_settings_params = [:additional_awesome_setting]

  # Set additional widgets available to the content editor
  # Default is []
  #
  # config.additional_widgets = [['custom_widget', 'WidgetClass']]

  # Set additional backend permitted page params
  # Default is []
  #
  # config.additional_page_params = [:additional_awesome_page_attribute]

  # Set additional backend permitted post params
  # Default is []
  #
  # config.additional_post_params = [:additional_awesome_post_attribute]

  # Configure the blog namespace.
  # Default is 'blog'
  #
  # config.blog_namespace = 'news'

  # Configure whether or not the blog is enabled.
  # Default is true
  #
  # config.blog_enabled = false

  # Specify what the root is. If this is not specified root is set to an Integral::Page
  # defined within Backend Settings.
  # Default is nil
  #
  # config.root_path = 'static_pages#home'

  # Configure page templates available (apart from the default) when creating a page.
  # Default is []
  #
  # config.additional_page_templates = [:full_width]

  # Configure what page paths are protected from user entry to prevent accidentally overriding
  # config.black_listed_paths = [
  #   '/admin/',
  #   '/blog/'
  # ]

  # Toggle production compression (HTML, JS, Gzip, minification, etc)
  # Default is true
  #
  # config.compression_enabled = false

  # Configure the maximum dimensions of images uploaded through CKeditor
  # Default is [1600, 1600]
  # config.editor_image_size_limit = [800, 800]

  # Configure whether images can be re-uploaded once the record has been saved.
  # If you're using a CDN this should be false to prevent caching issues.
  # Default is false
  #
  # config.editable_persisted_images = false

  # Configure image compression quality. 100 for lossless.
  # Default is 85
  #
  # config.image_compression_quality = 100

  # Configure the maximum dimensions of an image thumbnail version.
  # Default is [50, 50]
  #
  # config.image_thumbnail_size = [100, 100]

  # Configure the maximum dimensions of an image small version.
  # Default is [500, 500]
  #
  # config.image_small_size = [500, 500]

  # Configure the maximum dimensions of an image medium version.
  # Default is [800, 800]
  #
  # config.image_medium_size = [800, 800]

  # Configure the maximum dimensions of an image large version.
  # Default is [1600, 1600]
  #
  # config.image_large_size = [1600, 1600]

  # Configure the maximum description length for Posts & Pages
  # Default is 300
  #
  # config.description_length_maximum = 180

  # Configure the minimum description length for Posts & Pages
  # Default is 50
  #
  # config.description_length_minimum = 25

  # Configure the maximum title length for Posts & Pages
  # Default is 60
  #
  # config.title_length_maximum = 50

  # Configure the minimum title length for Posts & Pages
  # Default is 4
  #
  # config.title_length_minimum = 10
end
