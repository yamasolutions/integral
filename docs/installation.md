---
id: installing-integral
title: Install Integral CMS
sidebar_label: Install Integral CMS
---

## Installation

1. Create a new Rails application
```
  rails new example_app --database=postgresql -T
```
2. Add Integral to your Gemfile and run `bundle install`
 ```
  gem 'integral'
 ```
3. Run Integral install rake task (adds configuration initializers, installs routes & sets up database)
 ```
rails generate integral:install
 ```
4. Set the default host within the development environment, used for URL generation
```
# config/environments/development.rb

Rails.application.routes.default_url_options[:host] = 'http://localhost:3000'
```

5. Lastly, currently the block editor requires webpacker to be manually compiled - `rails integral:webpacker:compile`. Note, if you're pointing to a local version of Integral you can run `./bin/webpack --watch --colors --progress` within the integral directory. This will automatically update packs when changes are made.

Voila! Start your rails server and you're ready to go! You can access the user only area at `/admin`

*Integral requires Rails 5.2 or higher and Ruby 2.5.8 or higher.*

## Useful links

* [CHANGELOG](https://github.com/yamasolutions/integral/blob/master/CHANGELOG.md)
* [Code Documentation][code-docs-website]
* [Wish list](https://github.com/yamasolutions/integral/wiki/Wish-List)

## Bug reporting
If you discover a problem with Integral, we would love to know about it. Please use the [GitHub issue tracker][github-issue-tracker] to contact us about it.

If you have discovered a security related bug, please do NOT use the GitHub issue tracker. Send an email to patrick@yamasolutions.com

## Looking for help
If you have any questions please use [StackOverflow](https://stackoverflow.com) instead of the GitHub issue tracker.


[integral-cms]: https://integralrails.com
[contributing-guide]: https://github.com/yamasolutions/integral/blob/master/docs/contributing.md
[integral-github]: https://github.com/yamasolutions/integral
[version-website]: https://rubygems.org/gems/integral
[ci-website]: https://circleci.com/gh/yamasolutions/integral/tree/master
[code-climate-website]: https://codeclimate.com/github/yamasolutions/integral
[code-docs-website]: https://www.rubydoc.info/github/yamasolutions/integral
[github-issue-tracker]: https://github.com/yamasolutions/integral/issues
