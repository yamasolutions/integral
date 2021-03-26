PaperTrail.enabled = false

# Create User Roles
#
# * Reader - Useful for people just wanting to see whats going on like in future where there will be ‘Johnny updated page x’.
# * Contributor (i.e. guest blogger) - Same as reader but allowed to create, update and delete only their things - Can’t edit, delete or change status when it’s published
# * Editor - Create, Read & Update everything (can’t change status or page path) and delete own stuff
# * Manager
#
Integral::Role.create!(name: 'PageReader')
# Integral::Role.create!(name: 'PageContributer')
Integral::Role.create!(name: 'PageEditor')
Integral::Role.create!(name: 'PageManager')

Integral::Role.create!(name: 'UserManager')
Integral::Role.create!(name: 'FileManager')
Integral::Role.create!(name: 'PostManager')
Integral::Role.create!(name: 'ListManager')

# Demo User
user = Integral::User.create!({ name: 'Integrico', email: 'user@integralrails.com', password: 'password', role_ids: Integral::Role.ids, admin: true, status: 1 })

return if Rails.env.test? # Test DB should start with blank slate ... although roles and initial user are required

# Demo Page
host = URI.parse(Rails.application.routes.default_url_options[:host] || 'http://localhost:3000')

renderer = ApplicationController.renderer.new(
  http_host: host.to_s.sub(/^https?\:\/\//, '').sub(/^www./,''),
  https: host.scheme == 'https')

page = Integral::Page.new(title: 'Integral CMS - Demo Page',
                       description:'Integral CMS demo page. Integral is a rails content management system (CMS) which gives developers the ability to create a modern website with all the bells and whistles without the hassle.',
                       path: '/',
                       active_block_list: Integral::BlockEditor::BlockList.new(content: renderer.render('integral/pages/_demo', layout: false), active: true),
                       status: 1)
page.active_block_list.listable = page
page.save!

if Integral.blog_enabled?
  # Demo Post
  category = Integral::Category.create!(title: 'Uncategorised', description: "Posts which we haven't yet categorized but are sure to grab your attention", slug: 'uncategorized')
  post = Integral::Post.new(title: 'Integral CMS - Demo Post',
                         description: 'Integral CMS demo post. Integral is a rails content management system (CMS) which gives developers the ability to create a modern website with all the bells and whistles without the hassle.',
                         active_block_list: Integral::BlockEditor::BlockList.new(content: renderer.render('integral/posts/_demo', layout: false), active: true),
                         slug: 'integral-demo',
                         user: user,
                         tag_list: 'integral-cms,example-tag',
                         status: 1,
                         category: category)
  post.active_block_list.listable = post
  post.save!
end

# Main Menu
Integral::List.create!({ title: 'Main Menu', list_items: [
  Integral::Link.create!({title: 'Integral', url: '/'}),
  Integral::Link.create!({title: 'Documentation', url: 'https://github.com/yamasolutions/integral'}),
  Integral::Link.create!({title: 'Blog', url: '/blog'}),
  Integral::Link.create!({title: 'Demo Now', url: 'https://heroku.com/deploy?template=https://github.com/yamasolutions/integral-sample'})
]})

PaperTrail.enabled = true
