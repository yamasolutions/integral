Rails.application.configure do
  # Only compress when in production and compression is enabled
  break unless Rails.env.production? && Integral.compression_enabled?

  # Leverage Browser Caching
  config.static_cache_control = "public, max-age=31536000"

  # Strip all comments from JavaScript files, even copyright notices.
  ugly_opts =  {
    harmony: true,
    output: { comments: :none },
    compress: { unused: false }
  }

  uglifier = Uglifier.new(ugly_opts)

  config.assets.compile = true
  config.assets.debug = false

  config.assets.js_compressor = uglifier
  config.assets.css_compressor = :sass

  config.middleware.use Rack::Deflater
  config.middleware.insert_before ActionDispatch::Static, Rack::Deflater

  config.middleware.use HtmlCompressor::Rack,
    compress_css: false,
    compress_javascript: false,
    enabled: true,
    javascript_compressor: uglifier,
    preserve_line_breaks: false,
    remove_comments: true,
    remove_form_attributes: false,
    remove_http_protocol: false,
    remove_https_protocol: false,
    remove_input_attributes: false,
    remove_intertag_spaces: false,
    remove_javascript_protocol: true,
    remove_link_attributes: false,
    remove_multi_spaces: true,
    remove_quotes: false,
    remove_script_attributes: false,
    remove_style_attributes: false,
    simple_boolean_attributes: false,
    simple_doctype: false
end

