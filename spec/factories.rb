FactoryBot.define do
  sequence(:name) { |n| Faker::Name.name[0..20] }
  sequence(:email) { |n| Faker::Internet.email }
  sequence(:title) { |n| Faker::Book.title }
  sequence(:phone_number) { |n| Faker::PhoneNumber.phone_number[0..19] }
  sequence(:description) { |n| Faker::Lorem.paragraph(sentence_count: 8)[50..150] }
  sequence(:tag_list) { |n| Faker::Hipster.words(number: Faker::Number.between(from: 1, to: 5)) }
  sequence(:view_count) { rand(5000) }
  sequence(:url) { Faker::Internet.url }
  sequence(:integral_image) { |n| FactoryBot.create(:integral_storage_file, attachment: Rack::Test::UploadedFile.new(File.join(Integral::Engine.root, 'app', 'assets', 'images', 'integral', 'defaults', 'no_image_available.jpg'))) }

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
  end

  factory :role, class: Integral::Role do
    name { 'some_role' }
  end

  factory :integral_storage_file, class: 'Integral::Storage::File' do
    title
    description
    attachment { Rack::Test::UploadedFile.new(File.join(Integral::Engine.root, 'app', 'assets', 'images', 'integral', 'defaults', 'no_image_available.jpg')) }
  end

  factory :integral_page, class: 'Integral::Page' do
    title
    path { "/#{Faker::Lorem.words(number: 2).join('/')}" }
    description
    locale { Integral.frontend_locales.sample }
  end

  factory :integral_post, class: 'Integral::Post' do
    title
    description
    tag_list
    category
    user
    slug { Faker::Internet.slug(glue: '-') }
    # image { create(:integral_storage_file) }
    view_count
    created_at { Faker::Time.backward(days: 30) }
    published_at { Faker::Time.backward(days: 30) }
    status { rand(0..1) }
    locale { Integral.frontend_locales.sample }
  end

  factory :integral_notification, class: 'Integral::Notification::Notification' do
    recipient
    actor
    read_at { Faker::Time.backward(days: 30) }
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
    slug { Faker::Internet.slug(glue: '-') }
    # image { create(:integral_storage_file) }
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
    message { Faker::Lorem.paragraph(sentence_count: 8)[50..150] }
  end
end

