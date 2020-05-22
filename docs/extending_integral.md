---
id: extending-integral
title: Extending Integral
sidebar_label: Extending Integral
---

* [Adding a custom field](#adding-a-custom-field)
* [Adding a custom object](#adding-a-custom-object)
* [Overriding the default views](#overriding-the-default-views)
* [Overriding the default assets](#overriding-the-default-assets)
* [Troubleshooting](#troubleshooting)

## Adding a custom field

Below are step by step instructions on how to add a custom field to an Integral Page or Post. A [code sample][code-sample-custom-field] is available, you can also [deploy a demo application with Heroku][heroku-deploy-custom-field].

User story - As a page manager I want to be able to add a custom link to particular frontend pages. I want to be able to add, update and remove the link in the same backend screen I manage the pages.

We'll make this possible in 2 steps;
1. Update the database to store the links
2. Provide logged in users with a method of updating the links

First we'll create the migration to store a link within the `integral_pages` table;

```
bundle exec rails generate migration addCustomUrlToIntegralPages custom_url:string
```

Run `bundle exec rails db:migrate`. You can now set a link to a particular page - test it yourself using the `rails console`.

Now we need to provide users a way of updating the links themselves, we'll break this down into 2 steps;
1. Tell the backend pages controller to allow the `custom_url` attribute to be set
2. Update the backend page form to include a `custom_url` text field.

To update the permitted page params Integral provides a configuration option within it's initializer;
```
# config/initializers/integral.rb

config.additional_page_params = [:custom_url]
```

Now it's time to add the `custom_url` field input to the pages form. To do this we'll override the default pages form by copying Integral's backend views then removing all the files apart from `app/views/integral/backend/pages/_form.haml`. Now that we have only the page form we can add the text field wherever we like.

```
bundle exec rails generate integral:views -v backend
```

Boot your app and navigate as a logged in user to `/admin/pages/new`. You will now be able to create a page with a `custom_url`.

Stuck? Check out the [code sample][code-sample-custom-field] or [deploy a demo application with Heroku][heroku-deploy-custom-field]

If you want to add a custom field to another object for example an Enquiry or List you can follow these same instructions however instead of using an Integral initializer you'll need to manually override `resource_params` method within the backend controller.

## Adding a custom object

Below are step by step instructions on how to add a custom object to an Integral application. A [code sample][code-sample-custom-object] is available, you can also [deploy a demo application with Heroku][heroku-deploy-custom-object].

User stories;
* As a user I want to be able to manage special offers through Integral backend the same way I manage pages or posts.
* As a user I want to be able to subscribe and unsubscribe to notifications relating to special offers
* As a user I want to be able to see special offer activity on the main dashboard and within special offer screens
* As a visitor I want to be able to view special offers

We'll make this possible in 3 steps;
1. Update the database to store special offers & special offer activities (history)
2. Allow visitors to view special offers
3. Provide logged in users with a way of managing special offers through the Integral backend

### Data storage & visitor access

We'll start by using a Rails scaffold to create the `SpecialOffer` model, frontend views, routes and controller. This is the fastest way to get started, however this does generate a bunch of routes and views that we won't be using. The only routes and views that are actually required for the frontend as part of this demo are `index` and `show`

```
rails generate scaffold special_offer title:string description:string body:text discount:integer image_id:integer --no-assets --no-helper
```

Now we create a table which is used to store any changes relating to `SpecialOffer`. Generate a basic migration (`rails g migration createSpecialOfferVersions`) then replace the contents with;

```
  # The largest text column available in all supported RDBMS is
  # 1024^3 - 1 bytes, roughly one gibibyte.  We specify a size
  # so that MySQL will use `longtext` instead of `text`.  Otherwise,
  # when serializing very large objects, `text` might not be big enough.
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :special_offer_versions do |t|
      t.string   :item_type, {:null=>false}
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object, limit: TEXT_BYTES
      t.text     :object_changes, limit: TEXT_BYTES
      t.datetime :created_at
    end
    add_index :special_offer_versions, %i(item_type item_id)
  end
```

Update the empty `SpecialOffer` model with the following;

```
# app/models/special_offer.rb

class SpecialOffer < ApplicationRecord
  acts_as_integral
  has_paper_trail class_name: 'SpecialOfferVersion'

  # Validations
  validates :title, :description, :body, :discount, presence: true

  # Scopes
  scope :search, ->(search) { where('lower(title) LIKE ?', "%#{search.downcase}%") }

  # Associations
  belongs_to :image, class_name: 'Integral::Image', optional: true

  def self.decorator_class
    Integral::BaseDecorator
  end

  # @return [String] font awesome icon name representing modal - https://fontawesome.com/v4.7.0/icons/
  def self.integral_icon
    'percent'
  end

  # @return [Hash] dataset to render an integral backend instance card
  def to_card
    image_url = image.file.url if image
    {
      image: image_url,
      description: title,
      url: Rails.application.routes.url_helpers.special_offer_url(self),
      attributes: [
        { key: 'Discount', value: discount },
        { key: I18n.t('integral.records.attributes.updated_at'), value: I18n.l(updated_at) }
      ]
    }
  end
end
```

`acts_as_integral` does a couple of things behind the scenes;
* Registers with the backend main menu
* Registers with the backend create menu
* Registers with the main dashboard 'at a glance' chart
* Enables activity tracking - history will appear in recent activity widgets and within the admin activity grid
* Enables notification subscriptions

Next, create the `SpecialOfferVersion` which is the model that stores `SpecialOffer` changes;

```
# app/models/special_offer_version.rb

class SpecialOfferVersion < Integral::Version
  self.table_name = :special_offer_versions

  # NOTE: This is only required when using Postgres
  # https://github.com/paper-trail-gem/paper_trail#configuration
  self.sequence_name = :special_offer_versions_id_seq
end
```

Run `bundle exec rails db:migrate`. You can now perform CRUD actions on `SpecialOffer` at `/special_offers`. Create a couple special offers then remove the routes, views and controller actions that were created by the scaffold which we won't be using (only show & index are required).

Now it's time to update the controller that `SpecialOffersController` inherits from. This allows our `SpecialOffersController` to inherit all the behaviour from Integrals frontend controller including things like SEO and layout.

```
# app/controllers/special_offers_controller.rb

class SpecialOffersController < Integral::ApplicationController
```

That's the model and frontend sorted, now time to allow users to manage the special offers.

### Backend management

We'll break this down into 5 steps;
1. Add the backend routes
2. Add the backend controller
3. Add the backend views
4. Display activities

Let's start by adding the backend routes:
```
# config/routes.rb

  # Extend Integral engine routes
  Integral::Engine.routes.draw do
    namespace :backend, path: Integral.backend_namespace do
      resources :special_offers do
        get 'list', on: :collection
        member do
          get 'activities', controller: 'special_offers', as: :activities
          get 'activities/:activity_id', to: 'special_offers#activity', as: :activity
        end
      end
    end
  end
```

Next lets create the controller;
```
# app/controllers/integral/backend/special_offers_controller.rb

module Integral
  module Backend
    # Special Offers management
    class SpecialOffersController < BaseController
      before_action :set_resource, only: %i[edit update destroy show activities activity]

      private

      def resource_params
        params.require(:special_offer).permit(
          :title,
          :description,
          :body,
          :discount,
          :image_id
        )
      end

      def white_listed_grid_params
        [:descending, :order, :page, :user, :action, :object, :title]
      end
    end
  end
end
```

Now the grid which is used to display the special offers and provides filtering & sorting

```
# lib/integral/grids/special_offers_grid.rb

module Integral
  module Grids
    # Manages Special Offer filtering & sorting
    class SpecialOffersGrid
      include Datagrid

      scope do
        SpecialOffer.all.order('title DESC')
      end

      filter(:title) do |value|
        search(value)
      end

      column(:title, order: :title)
      column(:discount, order: :discount)
      column(:updated_at, order: :updated_at)
      column(:actions)
    end
  end
end
```

If you haven't already make sure you're loading `/lib` in your application:
```
# config/application.rb

config.eager_load_paths << Rails.root.join('lib')
```

Finally we need to create the backend views. The fastest way to do this is use the Integral views;
1. Copy Integrals backend views
```
rails g integral:views -v backend
```
2. Rename and `posts` folder to `special_offers`
```
mv app/views/integral/backend/posts/ app/views/integral/backend/special_offers
```
3. Make any changes necessary such as updating the form to only contain fields relating to `special_offers`
4. Remove the additional Integral backend views which were generated that you are not using

Lastly we need to create the authorization policy.

```
# app/policies/special_offer_policy.rb

# Handles Special Offer authorization
class SpecialOfferPolicy < Integral::BasePolicy
  # @return [Boolean] whether or not user has manager role
  def manager?
    # user.role?(role_name) || user.admin?
    true
  end

  # # @return [Symbol] role name
  # def role_name
  #   :special_offer_manager
  # end
end

```

You'll see above we've hardcoded the `manager?` method to return `true` which means any logged in user will have full access to Special Offers. If you want to enable authorization for this model uncomment the `role_name` method and `manager?` method content then create the special offer role and assign it to authorized users.

```
Integral::Role.create!(name: 'SpecialOfferManager')
```

We're done! You can now manage special offers through the user only area and view them as a visitor on the frontend.

Stuck? Check out the [code sample][code-sample-custom-object] or [deploy a demo application with Heroku][heroku-deploy-custom-object]

## Overriding the default views

Integral includes a generator to copy views into the host application.

```
  rails generate integral:views
```

By default this only copies over the frontend views. There are 4 sets of views: `frontend`, `backend`, `mailer` and `devise`. You can use the `-v` flag to control which views you wish to generate. For example, to copy all views over:

```
  rails generate integral:views -v frontend backend mailer devise
```

## Overriding the default assets

Integral includes a generator to copy assets (JS & views) into the host application.

```
  rails generate integral:assets
```

By default this only copies over the frontend assets. There are 3 sets of assets: `frontend`, `backend` and `email`. You can use the `-a` flag to control which assets you wish to generate. For example, to copy all assets over:

```
  rails generate integral:assets -a frontend backend email
```

### Just making small changes to the backend?
You can manually override the asset extension files located at:
```
  app/assets/stylesheets/integral/backend/overrides.sass
  app/assets/javascripts/integral/backend/extensions.js
```

### Just making small changes to styling on the frontend?
You can manually override the styling extension file located at:
```
  app/assets/stylesheets/integral/frontend/overrides.sass
```

## Overriding files manually

Just like any other engine or gem, you can override any Integral file by simply creating a file with the same name and extension in the same directory as Integral within your application. When Rails loads your application it will first check if a file exists within the host application, before then checking any dependancies.

For example if you're wanting to override the logo used in the backend area, save your image to the following location with your application:

```
  app/assets/images/integral/backend/logo.png
```

## Troubleshooting

Overridden a file and it doesn't seem to have done anything?

* Turn off caching
* Clear your assets `rake tmp:clear`
* Restart your application

[code-sample-custom-field]: https://github.com/yamasolutions/integral-sample/compare/sample-custom-field
[code-sample-custom-object]: https://github.com/yamasolutions/integral-sample/compare/sample-custom-object
[heroku-deploy-custom-field]: https://heroku.com/deploy?template=https://github.com/yamasolutions/integral-sample/tree/sample-custom-field
[heroku-deploy-custom-object]: https://heroku.com/deploy?template=https://github.com/yamasolutions/integral-sample/tree/sample-custom-object
