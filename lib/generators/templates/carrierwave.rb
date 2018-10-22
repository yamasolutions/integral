# :nocov:
CarrierWave.configure do |config|
  # Use AWS storage when in production, otherwise use file
  config.storage = Rails.env.production? ? :aws : :file

  # Disable processing when testing
  config.enable_processing = !Rails.env.test?

  # Below configuration is used for Production only.
  # This assumes you are using AWS for file storage in production (Recommended)
  #
  # Commment this line out and edit #4 when testing AWS locally
  break unless Rails.env.production?

  # The maximum period for authenticated_urls is only 7 days.
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

  # Set custom options such as cache control to leverage browser caching
  config.aws_attributes = {
    expires: 1.week.from_now.httpdate,
    cache_control: 'max-age=604800'
  }

  # AWS Configuration
  config.aws_bucket = ENV.fetch('AWS_S3_BUCKET_NAME')
  config.aws_acl    = 'public-read'
  config.aws_credentials = {
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
    region:            ENV.fetch('AWS_REGION') # Required
  }

  # CDN configuration (Recommended)
  # config.asset_host = 'https://cdn.example.com'
end
