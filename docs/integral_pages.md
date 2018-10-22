# Integral Pages

With integral pages you're able to set the exact path where you want the page to display. For example if you have a business which has multiple locations and you want to create a landing pages for all the locations as well as a page for each location you can do the following;
```
FactoryBot.create(:integral_page, path: '/locations')
FactoryBot.create(:integral_page, path: '/locations/england')
FactoryBot.create(:integral_page, path: '/locations/scotland')
FactoryBot.create(:integral_page, path: '/locations/ireland')
```

Other page features include;
* WYSIWYG Editor
* SEO Ready
* Drafting
* Custom templates
* Breadcrumbs
* Setting a main image

## Setting the homepage
The homepage can be set in Settings in the backend user area.

## Restricting paths
Configure what page paths are protected from user entry to prevent accidentally overriding.
```
# config/initializers/integral.rb
config.black_listed_paths = [
  '/admin/',
  '/blog/'
]
```

## Dynamic widgets
Dynamic widgets allow us to add dynamic content to a page. More information can be found within [Integral Widgets](https://integralrails.com)

## Page drafting
Pages which are set as draft are only viewable to logged-in users. All other users (visitors) are served a 404

## Templates
You can add page templates to Integral through the Integral config.
```
# config/initializers/integral.rb

config.additional_page_templates = [:fluid_width]
```
After you've added the template here add the template name in your locale files
```
integral:
  backend:
    pages:
      templates:
        fluid_width: Page with Fluid Width
```
Now if a user selects this template for a page Integral will try to render a view at ```app/views/integral/pages/templates/fluid_width.haml```

## Breadcrumbs
Breadcrumbs are handled by setting a parent on a Page. If a page has a parent then the breadcrumbs will be calculated and rendered. A Page can only be a parent if it is not a child and is published.

## WYSIWYG Editor
This editor is powered by [Ckeditor](https://github.com/galetahub/ckeditor). More information can be found within [WYSIWYG Editor](https://integralrails.com)

## Future works
Future works for Integral Pages include archiving and being able to add a preview image. More information can be found within the [WishList](https://github.com/yamasolutions/integral/wiki/Wish-List)
