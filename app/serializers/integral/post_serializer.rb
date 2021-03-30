module Integral
  # Used too transform Integral::Post records into JSON format
  class PostSerializer
    include FastJsonapi::ObjectSerializer

    attributes :title, :description, :status, :slug, :created_at, :updated_at, :published_at

    attribute :author do |post|
      post.author&.name
    end

    attribute :tags do |post|
      post.tags.map(&:name).join(',')
    end

    attribute :url do |post|
      post.frontend_url
    end

    attribute :featured_image do |post|
      post.image&.attached? ? Rails.application.routes.url_helpers.rails_blob_path(post.image.attachment) : nil
    end

    attribute :preview_image do |post|
      post.preview_image&.attached? ? Rails.application.routes.url_helpers.rails_blob_path(post.preview_image.attachment) : nil
    end
  end
end
