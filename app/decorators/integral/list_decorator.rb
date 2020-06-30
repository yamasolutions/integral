module Integral
  # List view-level logic
  class ListDecorator < BaseDecorator
    # @return [String] formatted title
    def title
      object.title
    end
  end
end
