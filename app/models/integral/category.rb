module Integral
  # Represents a user post category
  class Category < ApplicationRecord
    # has_paper_trail class_name: 'Integral::CategoryVersion'

    # Slugging
    extend FriendlyId
    friendly_id :title

    # Associations
    has_many :posts

    # Validations
    # validates_format_of :slug, :with => /\A[a-z0-9]+\z/i - Need to allow hypthens
    validates :title, presence: true, length: { minimum: 4, maximum: 60 }
    validates :description, presence: true, length: { minimum: 25, maximum: 300 }
  end
end
