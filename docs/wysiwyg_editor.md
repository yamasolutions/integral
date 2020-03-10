# WYSIWYG Editor
[CKeditor 4](https://ckeditor.com/ckeditor-4/) is the visual editor used to create content. This is provided through the [ckeditor-rails gem](https://github.com/galetahub/ckeditor). Editor features include;
* Easily create rich content such as headings, links, images & tables
* Embed iFrames to include things like YouTube videos & Flickr albums
* Add custom HTML widgets such as callout boxes, buttons & quotes
* Embed dynamic Integral widgets such as recent posts & dynamic lists

## Embedding dynamic widgets

Check our guide for more information on [Integral Widgets](https://github.com/yamasolutions/integral/blob/master/docs/integral_widgets.md)

## Overriding the editor

JS Configuration - Override this to add plugins, change the editor behaviour etc
```app/assets/javascripts/ckeditor/config.js.erb```

Stylesheet - Override this to change the appearence of the content within the editor
```app/assets/javascripts/ckeditor/contents.css```

## Loading custom fonts

If you'd like to load custom stylesheets, for example when using Google Web Font you'll have to override the [JS configuration file](https://github.com/yamasolutions/integral/blob/master/app/assets/javascripts/ckeditor/config.js.erb). Below is an example of an overridden loader file to load in two font families from GWF.

```
# app/assets/javascripts/ckeditor/config.js.erb

config.contentsCss = ['<%= stylesheet_path 'ckeditor/contents.css' %>', 'https://fonts.googleapis.com/css?family=Caveat+Brush|Open+Sans:400,400i,600,700|Saira+Extra+Condensed:400,500'];
```

## Embedding YouTube videos & social snippets
To enable autoembed when a URL is pasted into the editor for YouTube videos and twitter posts etc you'll need to do two things;
1. Sign up to a content provider such as [iFramely](https://iframely.com/plans)
2. Add your embed provider URL into the [JS configuration file](https://github.com/yamasolutions/integral/blob/master/app/assets/javascripts/ckeditor/config.js.erb)

More information can be found within the [Ckeditor docs](https://ckeditor.com/docs/ckeditor4/latest/features/media_embed.html#configuring-the-content-provider)

## Editor Improvements
There are a number of improvements in the [wishlist](https://github.com/yamasolutions/integral/wiki/Wish-List) relating to the editor including;
* Improved image management - Better UI with images linked to Integral Images
* Integral Widget Management
* Grid management
