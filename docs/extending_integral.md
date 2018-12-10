# Extending Integral

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

## Adding a custom field
TODO

## Adding a custom object
TODO


## Troubleshooting

Overridden a file and it doesn't seem to have done anything?

* Turn off caching
* Clear your assets `rake tmp:clear`
* Restart your application
