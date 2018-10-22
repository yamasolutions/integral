module Integral
  # Basic list item
  class Basic < ListItem
    # Validations
    validates :title, presence: true

    def basic?
      true
    end
  end
end
