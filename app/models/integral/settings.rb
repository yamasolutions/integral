module Integral
  # Stores configurable application settings
  class Settings < RailsSettings::Base
    field :main_menu_list_id, default: 1
    field :website_title, default: "Integral Rails"
    field :contact_email, default: "change-me@integralrails.com"
    field :default_preview_image_path, default: 'previews/default.jpg'
    field :google_tag_manager_id
    field :facebook_app_id
    field :twitter_handler
    field :facebook_url
    field :twitter_url
    field :instagram_url
    field :youtube_url
    field :linkedin_url
    field :github_url

    Integral.additional_settings.each do |setting, options|
      field setting, **options
    end
  end
end
