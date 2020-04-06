---
id: wysiwyg-editor
title: WYSIWYG Editor
sidebar_label: WYSIWYG Editor
---

[CKeditor 4](https://ckeditor.com/ckeditor-4/) is the visual editor used to create content. This is provided through the [ckeditor-rails gem](https://github.com/galetahub/ckeditor). Editor features include;
* Easily create rich content such as headings, links, images & tables
* Embed iFrames to include things like YouTube videos & Flickr albums
* Add custom HTML widgets such as callout boxes, buttons & quotes
* Embed dynamic Integral widgets such as recent posts & dynamic lists

## Embedding dynamic widgets

Check our guide for more information on [Integral Widgets](https://github.com/yamasolutions/integral/blob/master/docs/integral_widgets.md)

## Overriding the editor

JS Configuration - Override this to add plugins, change the editor behaviour etc
```app/assets/javascripts/ckeditor/my_config.js```

Stylesheet - Override this to change the appearence of the content within the editor
```app/assets/javascripts/ckeditor/my_contents.css```

StyleSet Configuration - Manages styles registration and loading
```app/assets/javascripts/ckeditor/my_styles.js```

## Loading custom fonts

If you'd like to load custom stylesheets, for example when using Google Web Font you'll have to override the [loader file](https://github.com/yamasolutions/integral/blob/master/app/assets/javascripts/ckeditor/loader.js.erb). Below is an example of an overridden loader file to load in two font families from GWF.
```
# app/assets/javascripts/ckeditor/loader.js.erb

//= require ckeditor/init

CKEDITOR.config.customConfig = '<%= javascript_path 'ckeditor/my_config.js' %>';
CKEDITOR.config.stylesSet = 'default:<%= javascript_path 'ckeditor/my_styles.js' %>';
CKEDITOR.config.contentsCss = ['<%= stylesheet_path 'ckeditor/my_contents.css' %>', 'https://fonts.googleapis.com/css?family=Caveat+Brush|Open+Sans:400,400i,600,700|Saira+Extra+Condensed:400,500'];
CKEDITOR.dtd.$removeEmpty.i = false;
```

## Editor Improvements
There are a number of improvements in the [wishlist](https://github.com/yamasolutions/integral/wiki/Wish-List) relating to the editor including;
* Twitter & Instagram embeds
* Improved image management - Better UI with images linked to Integral Images
* Integral Widget Management
* Grid management
* Performance - Fix obstructive JS
* Performance - Assets should go through asset pipeline
* Deployment - Reduce assets precompilation time - only pull in assets which are required
