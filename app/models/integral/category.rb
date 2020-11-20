module Integral
  # Represents a user post category
  class Category < ApplicationRecord
    acts_as_integral({
      icon: 'tags',
      backend_main_menu: { enabled: false },
      backend_create_menu: { enabled: false }
    })

    has_paper_trail versions: { class_name: 'Integral::CategoryVersion' }

    # Slugging
    extend FriendlyId
    friendly_id :title

    # Associations
    has_many :posts # TODO: Touch the posts on change
    belongs_to :image, class_name: 'Integral::Image', optional: true

    # Validations
    validates :slug, presence: true
    validates_format_of :slug, with: /\A[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*\z/
    validates :title, presence: true, length: { minimum: Integral.title_length_minimum,
                                                maximum: Integral.title_length_maximum }
    validates :description, presence: true, length: { minimum: Integral.description_length_minimum,
                                                      maximum: Integral.description_length_maximum }
    validates :locale, presence: true

    # Callbacks
    after_initialize :set_defaults

    def to_param
      id
    end

    def set_defaults
      return if self.persisted?

      self.locale ||= Integral.frontend_locales.first
    end
  end
end
