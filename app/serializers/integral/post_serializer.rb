module Integral
  # Used too transform Integral::Post records into JSON format
  class PostSerializer
    include FastJsonapi::ObjectSerializer

    attributes :title, :description, :status, :slug, :created_at, :updated_at, :published_at, :url, :body

    attribute :author do |post|
      post.author&.name
    end

    attribute :tags do |post|
      post.tags.map(&:name).join(',')
    end

    attribute :featured_image do |post|
      if post.featured_image&.file&.attached?
        Rails.application.routes.url_helpers.rails_representation_url(post.featured_image.file.variant(resize: "1200x1200").processed)
      end
    end

    attribute :preview_image do |post|
      if post.preview_image&.file&.attached?
        Rails.application.routes.url_helpers.rails_representation_url(post.preview_image.file.variant(resize: "1200x1200").processed)
      end
    end
  end
end
