FactoryBot.define do
  sequence(:name) { |n| Faker::Name.name[0..20] }
  sequence(:email) { |n| Faker::Internet.email }
  sequence(:title) { |n| Faker::Book.title }
  sequence(:body) { |n| File.read(File.join(Integral::Engine.root.join('public', 'integral', 'ckeditor_demo_content.html'))) }
  sequence(:phone_number) { |n| Faker::PhoneNumber.phone_number[0..19] }
  sequence(:description) { |n| Faker::Lorem.paragraph(8)[50..150] }
  sequence(:tag_list) { |n| Faker::Hipster.words(Faker::Number.between(1, 5), true, true) }
  sequence(:view_count) { rand(5000) }
  sequence(:url) { Faker::Internet.url }

  factory :integral_user, class: Integral::User, aliases: [:user, :recipient, :actor] do
    name
    email
    password               { "password" }
    password_confirmation  { "password" }

    factory :integral_admin_user do
      admin { 1 }
    end

    factory :settings_manager do
      role_ids { [ Integral::Role.find_by_name('SettingsManager').id ] }
    end

    factory :page_manager do
      role_ids { [ Integral::Role.find_by_name('PageManager').id ] }
    end

    factory :post_manager do
      role_ids { [ Integral::Role.find_by_name('PostManager').id ] }
    end

    factory :user_manager do
      role_ids { [ Integral::Role.find_by_name('UserManager').id ] }
    end

    factory :list_manager do
      role_ids { [ Integral::Role.find_by_name('ListManager').id ] }
    end

    factory :image_manager do
      role_ids { [ Integral::Role.find_by_name('ImageManager').id ] }
    end
  end

  factory :role, class: Integral::Role do
    name { 'some_role' }
  end

  factory :image, class: Integral::Image do
    title
    description
    width { 1 }
    height { 2 }
    file { Rack::Test::UploadedFile.new(File.join(Integral::Engine.root, 'spec', 'support', 'image.jpg')) }
  end

  factory :integral_page, class: 'Integral::Page' do
    title
    path { "/#{Faker::Lorem.words(2).join('/')}" }
    description
    body
  end

  factory :integral_post, class: 'Integral::Post' do
    title
    description
    tag_list
    category
    user
    slug { Faker::Internet.slug(nil, '-') }
    image
    body
    view_count
    created_at { Faker::Time.backward(30) }
    published_at { Faker::Time.backward(30) }
    status { rand(0..1) }
  end

  factory :integral_notification, class: 'Integral::Notification::Notification' do
    recipient
    actor
    read_at { Faker::Time.backward(30) }
    action { ['create', 'update', 'destroy'].sample }
    association(:subscribable, factory: :integral_post)
  end

  factory :integral_notification_subscription, class: 'Integral::Notification::Subscription' do
    state { [:subscribe, :unsubscribe].sample }
    association(:subscribable, factory: :integral_post)
    user
  end

  factory :integral_category, class: 'Integral::Category', aliases: [:category] do
    title
    description
    slug { Faker::Internet.slug(nil, '-') }
    image
  end

  factory :integral_post_viewing, class: 'Integral::PostViewing' do
    post { create(:integral_post) }
    ip_address { Faker::Internet.ip_v4_address }
  end

  factory :integral_list_item_basic, class: 'Integral::Basic', aliases: [:integral_list_item] do
    title
  end

  factory :integral_list_item_link, class: 'Integral::Link' do
    title
    url
  end

  factory :integral_list_item_object, class: 'Integral::Object' do
    object_type { 0 }
    object { create(:integral_post) }
  end

  factory :integral_list, class: 'Integral::List' do
    title
    description
    list_item_limit { rand(1..10) }
    children { true }
    hidden { false }
  end

  factory :integral_enquiry, class: 'Integral::Enquiry' do
    name
    email
    subject { Faker::Book.title }
    message { Faker::Lorem.paragraph(8)[50..150] }
  end

  factory :integral_lighthouse_audit, class: 'Integral::Lighthouse::Audit' do
    url
    emulated_form_factor { 'mobile' }
    throttling_method { 'simulate' }
    categories { '' }
    performance_score { rand }
    accessibility_score { rand }
    best_practices_score { rand }
    pwa_score { rand }
    seo_score { rand }
    response { { foo: :bar } }
    # auditable_id { '' }
    # auditable_type { '' }
  end
end

