# Extending Integral

## Overriding the default views

Integral includes a generator to copy views into the host application.

```
  rails generate integral:views
```

By default this only copies over the frontend views. There are 4 sets of views: `frontend`, `backend`, `mailer` and `devise`. You can use the `--views` flag to control which views you wish to generate. For example, to copy all views over:

```
  rails generate integral:views --views frontend backend mailer devise
```

## Overriding the default assets

## Adding a custom field

## Adding a custom object

