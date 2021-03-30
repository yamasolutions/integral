# :nocov:
##
# SitemapGenerator configuration
#
# To generate a sitemap run 'rake sitemap:refresh'
#
# Runn this task at least once/day (depending on the size of the website) to keep sitemap up to date.
# Heroku Scheduler or a cron job can be used to do this.
#
# https://github.com/kjvarga/sitemap_generator#sitemap-configuration
# #

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.application.routes.default_url_options[:host]

# Best to compress (gzip) the sitemap, however some analytics tools require uncompressed
# SitemapGenerator::Sitemap.compress = false

# Remote sitemap storage config - Use this if you're running on a ephemeral filesystem (Heroku)
# SitemapGenerator::Sitemap.sitemaps_host = "https://s3-#{ENV.fetch('AWS_REGION')}.amazonaws.com/#{ENV.fetch('AWS_S3_BUCKET_NAME')}/"
# SitemapGenerator::Sitemap.public_path = 'tmp/'
# SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
# SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(ENV.fetch('AWS_S3_BUCKET_NAME'),
#   aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
#   aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
#   aws_region: ENV.fetch('AWS_REGION')
# )

SitemapGenerator::Sitemap.create do
  # Add page paths
  Integral::Page.published.find_each do |page|
    add page.path, lastmod: page.updated_at
  end

  if Integral.blog_enabled?
    integral = Integral::Engine.routes.url_helpers
    add integral.posts_path
    add integral.tags_path

    Integral::Post.published.find_each do |object|
      add integral.post_path(object), lastmod: object.updated_at
    end
  end
end
