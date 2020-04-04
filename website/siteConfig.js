/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// See https://docusaurus.io/docs/site-config for all the possible
// site configuration options.

// List of projects/orgs using your project for the users page.
// const users = [
//   {
//     caption: 'User1',
//     // You will need to prepend the image path with your baseUrl
//     // if it is not '/', like: '/test-site/img/image.jpg'.
//     image: '/img/undraw_open_source.svg',
//     infoLink: 'https://www.facebook.com',
//     pinned: true,
//   },
// ];

const siteConfig = {
  title: 'Integral CMS',
  tagline: 'Create a website (which does stuff) within minutes powered by Rails.',
  url: 'https://yamasolutions.github.io',
  baseUrl: '/integral/',
  projectName: 'integral',
  organizationName: 'yamasolutions',

  // For no header links in the top nav bar -> headerLinks: [],
  headerLinks: [
    { href: "https://integralrails.com", label: "Integral" },
    { doc: 'introduction', label: 'Documentation' },
    { href: "https://integralrails.com/blog", label: "Blog" },
    { href: "https://heroku.com/deploy?template=https://github.com/yamasolutions/integral-sample", label: "Deploy Now", external: true },
    { blog: false }
  ],

  // // If you have users set above, you add it here:
  // users,

  headerIcon: 'img/favicon.ico',
  footerIcon: 'img/favicon.ico',
  favicon: 'img/favicon.ico',

  colors: {
    primaryColor: '#03a9f4',
    secondaryColor: '#0a0a0a'
  },

  stylesheets: [
    'https://fonts.googleapis.com/css?family=Montserrat:400,400i,700&display=swap'
  ],

  // This copyright info is used in /core/Footer.js and blog RSS/Atom feeds.
  copyright: `Copyright © ${new Date().getFullYear()} Integral CMS`,

  highlight: {
    // Highlight.js theme to use for syntax highlighting in code blocks.
    theme: 'default',
  },

  // Add custom scripts here that would be placed in <script> tags.
  scripts: ['https://buttons.github.io/buttons.js'],

  // On page navigation for the current documentation page.
  onPageNav: 'separate',
  // No .html extensions for paths.
  cleanUrl: true,

  // // Open Graph and Twitter card images.
  // ogImage: 'img/undraw_online.svg',
  // twitterImage: 'img/undraw_tweetstorm.svg',

  // For sites with a sizable amount of content, set collapsible to true.
  // Expand/collapse the links and subcategories under categories.
  // docsSideNavCollapsible: true,

  // Show documentation's last contributor's name.
  // enableUpdateBy: true,

  // Show documentation's last update time.
  // enableUpdateTime: true,

  // You may provide arbitrary config keys to be used as needed by your
  // template. For example, if you need your repo's URL...
  repoUrl: 'https://github.com/yamasolutions/integral'
};

module.exports = siteConfig;
