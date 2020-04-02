# Deploying to Production

This guide discusses two things;
* [Essential setup](#essential-production-setup) - Tasks that you will need to perform to ensure all Integral features run properly in production
* [Suggested setup](#suggested-additional-setup) - Tasks that we recommend any production application performs

This isn't a guide on how to make your application accessible on the internet at a particular URL. There are many ways to do this, whether its doing it all yourself by setting up a server on something like [Digitalocean](https://digitalocean.com) or by using a platform as a service such as [Heroku](https://heroku.com).

If you're looking for the fastest way to get your application available at a particular URL checkout our guide on [deploying with Heroku](https://github.com/yamasolutions/integral/blob/master/docs/heroku.md).

## Essential production setup

### Set host
Set the website host, used within URL generation.
```
Rails.application.routes.default_url_options[:host] = 'https://example.org'
```

### Connect Mail
Rails has a great guide all about [Action Mailer & How to send email with Rails](https://guides.rubyonrails.org/action_mailer_basics.html). User invites and enquiry auto replies are two features which require Action Mailer to be setup.

Setting up Rails to send emails with Gmail is a simple as adding the snippet below to your production config file and setting the apprioprate environment variables.

```
# config/environments/production.rb

config.action_mailer.delivery_method = :smtp
config.action_mailer.default_url_options = { host: Rails.application.routes.default_url_options[:host] }
config.action_mailer.smtp_settings = {
  address:              ENV['SMTP_ADDRESS'] || 'smtp.gmail.com',
  port:                 ENV['SMTP_PORT'] || 587,
  user_name:            ENV['SMTP_USER_NAME'],
  password:             ENV['SMTP_PASSWORD'],
  authentication:       'plain',
  enable_starttls_auto: true
}
```

### File uploading (Carrierwave) setup

Integral uses [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) to manage file uploading and assumes you will be storing the files on [Amazon S3](https://aws.amazon.com/s3/).

To configure file uploading set the following environmental variables;
* ``` AWS_S3_BUCKET_NAME ```
* ``` AWS_ACCESS_KEY_ID ```
* ``` AWS_SECRET_ACCESS_KEY ```
* ``` AWS_REGION ```

This information can be found on your Amazon S3 account.

If you are not using Amazon S3 you can change the Carrierwave config file ```config/initializers/carrierwave.rb```. This file was automatically copied in when you installed Integral. You'll also want to update ```config/sitemap.rb``` as the sitemap generator assumes you're using S3.


## Suggested additional setup

### Background Jobs

By default all jobs will run asynchronously, which means when someone uploads a file or a person sends an enquiry those tasks (image processing & email creation) will run straight away therefore blocking the application from processing anymore requests until they're finished. More info;

* [How Rails handles background jobs](https://edgeguides.rubyonrails.org/active_job_basics.html)
* [A comparison of queue adapters](https://github.com/collectiveidea/delayed_job)

Integral does not impose a specific queue adapter as this will vary between applications. If you have a small application and want to get started as soon as possible we recommend [Delayed Jobs](https://github.com/collectiveidea/delayed_job).

Note: When you decide on a queue adapter you'll need to update the [Carrierwave Backgrounder](https://github.com/patricklindsay/carrierwave_backgrounder) config at `config/initializers/carrierwave_backgrounder.rb`

### Site Security
It goes without saying but we'll say it anyway - Make sure to enable (and force) SSL for all your applications.
```
config.force_ssl = true
```

### Sitemap generation
Setup a CRON job or if you're using Heroku install the [Heroku Scheduler](https://elements.heroku.com/addons/scheduler) addon to regularly update the sitemap.
``` rake sitemap:refresh```

Remember to update your `robots.txt` with where the sitemap is located
```
# public/robots.txt
User-agent: *
Disallow: /admin
Sitemap: https://s3.eu-west-2.amazonaws.com/yama-solutions/sitemaps/sitemap.xml
```

### Error monitoring
Never miss an error - install an error tracking management tool such as [Rollbar](https://rollbar.com) or [HoneyBadger](https://www.honeybadger.io/)

### Performance monitoring
Monitor performance & analysis slow responses - install a performance monitoring tool such as [NewRelic](https://newrelic.com/) or [Scout](https://scoutapp.com/)

### Request Throttling
Protect your Rails and Rack apps from bad clients. [Rack Attack](https://github.com/kickstarter/rack-attack) lets you easily decide when to allow, block and throttle requests.

### Content Delivery Network (CDN)
Setting up a CDN in Rails is super easy and can really help performance on websites, espically those with a large amount of media. Check out [Amazon Cloudfront](https://aws.amazon.com/cloudfront).

### Analytics tools
Other tools worth checking out
* [Google Search Console](https://search.google.com/search-console)
* [Google Analytics](https://analytics.google.com)
* [Pingdom](https://pingdom.com) - Uptime monitoring
* [SEMRush](https://semrush.com) - Internet marketing
