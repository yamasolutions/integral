# Changelog

This project follows [semver 2.0.0](http://semver.org/spec/v2.0.0.html) and the
recommendations of [keepachangelog.com](http://keepachangelog.com/).

## Unreleased

### Added

- Notifications dropdown with read and unread states
- Notification subscribing & unsubscribing to everything, particular classes & individual objects
- Added User statuses - pending, active & blocked
- User managers can now block other users from logging in and accessing any backend functionality
- Devise Emails now use the Integral mailer layout
- Default action bar content for index & show actions
- CharactorCounter can now be added to inputs which do not have a maxlength set
- List Management - Added CharactorCounter to list item fields
- Backend image and list dashboard, activity, & show pages
- Backend helpers `render_resource_grid` & `render_resource_grid_form` to reduce view duplication
- Backend helper extension for `link_to` to allow passing of `wrapper` & `icon` options

### Fixed

- Admin bar - Add white background and bring to front
- Backend posts form - Existing tag suggestions were not appearing when typing in input
- Image Uploader - Initial uploaded image was not displaying
- Backend grid context menu not appearing for dynamic loaded rows

### Dependancies
- Bump Foundation to 6.6.2
- Swap out poltergeist & PhantomJS for Apparition
- Bump Ruby to 2.5.8

## v1.4.0 - 2020-04-17

### Breaking Changes

- If any Post or Page content contains images with class of 'lazyload' you'll need to use the `#editor_body` method when instaniating Ckeditor otherwise the lazyload images will not appear within the editor
- All Posts must be associated to an Integral::Category through the `category` association

### Changed
- Recent activity widget scope - Ignore history with no user associated

### Added

- Add user, post and page dashboards
- Add recent activity cards on backend dashboards & object show pages
- Add backend post and page show pages
- Blog - Improved default frontend blog styling
- Blog - Added Post category management & category listing pages - Every post must have one category
- Add webhook management for Post creation, updates, deletion and publication
- Gallery - Handles pausing YouTube videos on close
- Gallery - When only one item is present no longer shows thumbnail gallery and gallery controls
- LazyLoading - Automatically mark Twitter & Instgram oEmbeds as Lazy Loads and handle lazy loading images with the 'lazyload' class
- Updated Suggest Tags input to accept freeInput option (defaults to true) - when set to false only provided typeahead tags are valid
- Set default title and notifications to Integral Backend CRUD endpoints
- Pages - Added 'Archived' status
- Remote Form - Added reset-on-success option to allow preventing the reseting of forms
- Swiper List Page Widget - Add optional 'html_classes' option
- Add `render_card` backend helper

### Fixed

- Lists - Unescape URLs within the renderer rather than on the view (handles nil cases)
- Users - Searching by name in backend
- Post cloning - Do not copy over `published_at`
- Record Selector - Fix image not displaying correctly in details sidebar
- Lists are touched on any list item activity

### Performance

- Frontend Post Index - Remove N+1 for user & images
- Backend activities - Improved grid search by removing changeset from query

### Dependencies
-

## v1.3.0 - 2019-09-14

### Breaking Changes

-

### Added

-

### Fixed

-

### Dependancies
- Rails - Update to 5.2.x


## v1.2.0 - 2019-09-14

### Breaking Changes

- Removed Pickadate - Use Jquery Datepicker instead

### Added

- Post, Page & List cloning
- Add JSON-LD on the blog index and show pages
- Ckeditor - Add link balloon toolbar
- Ckeditor - Use Enhanced Image plugin
- Ckeditor - Use SCAYT (spell checker) by default
- Ckeditor - Add Foundation Callout plugin - Makes callouts widgets which are draggable and removable
- User login - In development default the login form to the first user and do not validate passwords
- Posts - Can now update author of a post
- Grids - When grid filtering fails display error message to user
- RemoteForm now allows overriding of callbacks
- Post searching - Backend search now searches by slug as well as title
- Page searching - Backend search now searches by path as well as title

### Fixed

- Open social links in new tab & add rel noopener to each link
- Backend - Reduce duplication within controllers
- Posts - Fix filtering
- List Management - Unescape special characters when displaying URLs of objects
- Readded instagram URL editing in backend & remove Google+
- Move ApplicatonController's override of render to public

### Dependancies

- Ckeditor - Update to 4.11.1

## v1.1.0 - 2018-12-24

### Breaking Changes

- None

### Added

- Can disable input character counter by adding `data-character-counter='false'` to inputs
- Disabled input character counter for login password field
- Improved onboarding - install script now handles route & seed creation as well as DB setup
- Improved onboarding - added generator for Integral views `rails g integral:views`
- Improved onboarding - added generator for Integral assets `rails g integral:assets`
- Gallery arrow control and size constraint to viewport size

### Fixed

- Moved list edit form to /edit route & removed show route
- Dashboard displays most recent post & page
- Post data appears in dashboard widgets when blog is enabled
- Recent Posts widget orders collection by most recently published
- Demo images no longer causing 404s
- Canonical URL for homepage

### Dependancies
- Bumped Devise to `~> 4.5.0` - Fixes `secret_key_base` production issue

## v1.0.1 - 2018-11-04

### Breaking Changes

- None

### Added

- Tooltip to explain media query indicator & helper method to toggle whether it displays

### Fixed

- 'Errno::ENOENT: No such file' issue caused by Ckeditor demo content file not being included

## v1.0.0 - 2018-10-22

### Breaking Changes

- None

### Added

* Frontend - Dynamic pages
* Frontend - Integrated Blog
* Frontend - SEO Ready
* Frontend - Contact form procesing w/ HTML emails & autoreply
* Frontend - Newsletter signup tracking
* Frontend - Remote form helper
* Frontend - Sitemap generation
* Backend - Sleek admin area
* Backend - User authentication & authorisation
* Backend - Activity tracking
* Backend - User management (CRUD)
* Backend - Post management (CRUD)
* Backend - Page management (CRUD)
* Backend - Image management (CRUD)
* Backend - List management (CRUD)
* Backend - Settings management

### Fixed

- None

