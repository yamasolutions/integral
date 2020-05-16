---
id: contributing
title: Contributing
sidebar_label: Contributing
---

We'd love your help with Integral. There are many ways you can contribute such as;
1. Bug reporting & QA
2. Contributing bug fixes or new features
3. Assistance maintaining, improving and expanding documentation
4. Translation - Help us translate the backend!

## Bug reporting & QA

If you've found a bug please report it by creating a [GitHub issue](https://github.com/yamasolutions/integral/issues). The more detail you provide about the issue the more likely it is to be resolved faster. Ideally provide a [minimal working example](https://en.wikipedia.org/wiki/Minimal_working_example) which is available at a public repo so that the issue can easily be reproduced.

## Bug fixing & feature implementation

Great, we can always use help developing Integral! Simply fork the repo to get started. If you're looking for something to work on check out [GitHub issue tracker](https://github.com/yamasolutions/integral/issues) or the [WishList](https://github.com/yamasolutions/integral/wiki/Wish-List).


### Running tests

To test Integral run the following command;

```
bundle exec rspec spec
```

The test suite will run the following;
* [Rspec](http://rspec.info/) - Test suite

If any of the above fail the build will fail.

### Creating a pull request

If you'd like to submit a pull request please adhere to the following:
* All code changes must be accompanied with tests (or a good reason not to have them). Make sure the build is passing before creating a PR
* Two spaces instead of tabs
* General [Rails naming conventions](https://gist.github.com/iangreenleaf/b206d09c587e8fc6399e) for files and classes.
* Useful commit messages

If you do not follow the above points your PR will most likely be closed.

## Contributing to documentation

Think we can improve on documentation? Help us out by letting us know - create a [GitHub issue](https://github.com/yamasolutions/integral/issues) or even better fork the repo and submit a PR.

## Translating Integral

We'd love to make Integral available to as many languages as possible. If you feel you can help us with this please submit a PR with the relevant locale files and we'll be sure to take a look.


## Version Releases

* Confirm CI build is passing and docs are up to date
* Set new version number
* Update changelog
* Bundle
* rake build
* Publish new gem to RubyGems
* Commit
* Push commit to GitHub
* Create tag and push to GitHub
* Update docs website
  - cd to `website` directory
  - run  `yarn build`
  - run  `yarn run publish`
  - Confirm docs website has updated
* Write up and publish integralrails.com blog post
* Win!
