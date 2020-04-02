# Integral Widgets

Integral widgets are placed within the [WYSIWYG editor](https://github.com/yamasolutions/integral/blob/master/docs/wysiwyg_editor.md) to embed dynamic content.

Currently there are two widgets;
* Recent Posts
* Swiper List

## How the dynamic content is rendered

Take for example an Integral page, this has a `body` attribute which stores raw HTML which can be updated by editing the WYSIWYG editor.

To output the raw HTML from the editor as is, we could do `page.body.html_safe` within a view.

This would work well, however we want to embed dynamic data. So instead we first pass the raw HTML through a renderer helper, `Integral::ContentRenderer.render(page.body)`.

This renderer parses the html to check if there are any widget placeholders present, if there are placeholders present it will replace the placeholder with dynamic content generated from the placeholder data.

For example, the placeholder below will be replaced with a collection of recent posts tagged with `integral-how-to`.

```
<p class='integral-widget' data-widget-type='recent_posts' data-widget-value-tagged='integral-how-to'>
```

Note: Within frontend views you can use the `render_content` helper rather than calling `Integral::ContentRenderer` directly
```
render_content(page.body)
```

## Types of widgets
### Recent Posts

As mentioned, the recent posts widget outputs a collection of the most recent published posts. Options for this widget are;
* `tagged` - Scope the posts to a particular tag, default is blank
* `amount` - Limit the amount of posts to display, default is 2

```
<p class='integral-widget' data-widget-type='recent_posts' data-widget-value-tagged='integral-how-to' data-widget-value-amount='4'>
```


### Swiper List

As mentioned, the recent posts widget outputs a collection of the most recent published posts. Options for this widget are;
* `tagged` - Scope the posts to a particular tag, default is blank
* `amount` - Limit the amount of posts to display, default is 2

```
<p class='integral-widget' data-widget-type='swiper_list' data-widget-value-slide-view-path='shared/testimonial'>
```

## Creating a custom widget

1. Create your custom Integral widget class. All this needs to do is implement `.render` which returns a string
```
# lib/cool_widget.rb

class CoolWidget
  # Renders something dynamic and cool
  def self.render(options = {})
    '<p>Cool widget HTML</p>'
  end
end
```
2. Add your custom widget to the Integral config at `config/initializers/integral.rb`

```
config.additional_widgets = [['cool_widget', 'CoolWidget']]
```

3. Add a placeholder to the widget within the WYSIWYG editor

```
<p class='integral-widget' data-widget-type='cool_widget'>
```

Done! You can also pass options to the widget, for an example check out how `RecentPosts` and `SwiperList` work.
