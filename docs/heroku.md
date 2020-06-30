---
id: heroku-deployment
title: Deploying with Heroku
sidebar_label: Deploying with Heroku
---

# Heroku

[Heroku](https://www.heroku.com/) offers a platform as a service which is commonly used by Ruby on Rails developers to host their projects. Although more expensive then just renting out servers, this expense is offset by time saved not worrying about developer operations such as server security, availability, monitoring, scaling etc.

Would you like to get started right away and deploy a sample application? [Deploy to Heroku now!](https://heroku.com/deploy?template=https://github.com/yamasolutions/integral-sample)

Otherwise if you'd like to deploy an app that you've created carry on reading...

## Deploying Integral with Heroku

Deploying Integral using Heroku is just like deploying any other Ruby on Rails application. If you're new to Heroku it's worth checking out their article [getting start with Rails](https://devcenter.heroku.com/articles/getting-started-with-rails5).

This guide assumes the following;
1. You have successfully setup [Integral](https://github.com/yamasolutions/integral/) and can access it locally
2. Your applications database is using [Postgres](https://www.digitalocean.com/community/tutorials/how-to-setup-ruby-on-rails-with-postgres)
3. Your project is stored in [Git](https://www.atlassian.com/git/tutorials/what-is-git)
4. You have an active account with [Heroku](https://www.heroku.com/)
5. You have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install) installed
6. You have followed the [essential production setup steps](https://github.com/yamasolutions/integral/blob/master/docs/deploying_to_production.md)

### The step by step
1. Create a [Procfile](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#procfile) at the root of your project - This tells Heroku how to run the application.
```
# Procfile
web: bundle exec puma -C config/puma.rb
```
No need to create the config file - Rails 5 automatically generates this when creating a new project.

2. Create a blank Heroku app
```heroku create example_app```
3. Within your project directory, link the Heroku app you just created to Git.
```heroku git:remote -a example_app```
4. Push your project up to the new Heroku app - Make sure you have first checked everything into git.
```git push heroku master```
5. Thats it! Check the Heroku Project URL to view your application. For this example the URL would be;
``` https://example_app.herokuapp.com```

It will take a few minute to deploy, if it doesn't appear or it looks like there has been an issue go to your [Heroku dashboard](https://dashboard.heroku.com/apps) and see if there was a problem deploying the application.


### Things you'll want to do next (post deploy)

1. Add the image optimizer buildpack to your Heroku app so that your application can compress and resize images
``` heroku buildpacks:add --index 2 https://github.com/yamasolutions/image-optimizers-buildpack ```
2. Heroku Pipelines - Never has it been easier to test your project in production. [Setup a Heroku pipeline](https://devcenter.heroku.com/articles/pipelines), link it to Github and enable review apps for every project.
3. Create a staging app within the Heroku pipeline - Very useful for testing features before they hit live.
4. Install addons (see below)
5. [Plus other non Heroku related things...](https://github.com/yamasolutions/integral/blob/master/docs/deploying_to_production.md)

### Troubleshooting & things that may go wrong
* Make sure to push app directly to heroku through command line rather than manual deploy through web app. This means it will create all the required environment variables.
* You may need to turn on dynos through the Heroku UI
* Review apps - Base your review app off your staging app rather than your production app - Don't want to override production data!
* Review apps - Make sure you post deploy script is executable `chmod a+x post-deploy.sh`
* Missing environment variables, did you forget to setup AWS S3 for image uploads?


## Useful addons
* [Autobus](https://elements.heroku.com/addons/autobus) - Automated database backups
* [Papertrail](https://elements.heroku.com/addons/papertrail) & [Logentries](https://elements.heroku.com/addons/logentries) - Logging
* [Heroku Scheduler](https://elements.heroku.com/addons/scheduler) - Schedule things like DB cleanups, sitemap generation etc
* [Rollbar](https://elements.heroku.com/addons/rollbar) - Error monitoring
* [NewRelic](https://elements.heroku.com/addons/newrelic) - Application monitoring
