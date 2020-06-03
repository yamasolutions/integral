module Integral
  # Represents a user post category
  class Category < ApplicationRecord
    acts_as_integral({
      backend_main_menu: { enabled: false },
      backend_create_menu: { enabled: false }
    })

    has_paper_trail class_name: 'Integral::CategoryVersion'

    # Slugging
    extend FriendlyId
    friendly_id :title

    # Associations
    has_many :posts # TODO: Touch the posts on change
    belongs_to :image, class_name: 'Integral::Image', optional: true

    # Validations
    validates :slug, presence: true
    validates_format_of :slug, with: /\A[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*\z/
    validates :title, presence: true, length: { minimum: 4, maximum: 60 }
    validates :description, presence: true, length: { minimum: 25, maximum: 300 }

    def self.integral_icon
      'tags'
    end
  end
end
