module Integral
  # Represents an alternate resource association, i.e. a page can have an alternate page which has the same content but in a different language
  class ResourceAlternate < ApplicationRecord
    # Associations
    belongs_to :resource, polymorphic: true
    belongs_to :alternate, polymorphic: true
  end
end
