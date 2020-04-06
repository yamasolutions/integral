const siteConfig = {
  title: 'Integral CMS',
  tagline: 'Create a website (which does stuff) within minutes powered by Rails.',
  url: 'https://yamasolutions.github.io',
  baseUrl: '/',
  projectName: 'integral',
  organizationName: 'yamasolutions',

  headerLinks: [
    { href: "https://integralrails.com", label: "Integral" },
    { doc: 'introduction', label: 'Documentation' },
    { href: "https://integralrails.com/blog", label: "Blog" },
    { href: "https://heroku.com/deploy?template=https://github.com/yamasolutions/integral-sample", label: "Deploy Now", external: true },
    { blog: false }
  ],

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

  highlight: {
    // Highlight.js theme to use for syntax highlighting in code blocks.
    theme: 'default',
  },

  scripts: ['https://buttons.github.io/buttons.js'],
  onPageNav: 'separate',
  cleanUrl: true,

  // ogImage: 'img/undraw_online.svg',
  // twitterImage: 'img/undraw_tweetstorm.svg',

  // docsSideNavCollapsible: true,
  // enableUpdateBy: true,
  // enableUpdateTime: true,

  repoUrl: 'https://github.com/yamasolutions/integral',
  editUrl: 'https://github.com/yamasolutions/integral/blob/master/docs/',
  copyright: `Copyright © ${new Date().getFullYear()} Integral CMS`
};

module.exports = siteConfig;
