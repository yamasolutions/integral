# Changelog

This project follows [semver 2.0.0](http://semver.org/spec/v2.0.0.html) and the
recommendations of [keepachangelog.com](http://keepachangelog.com/).

## Unreleased

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

