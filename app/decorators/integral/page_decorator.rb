module Integral
  # Page view-level logic
  class PageDecorator < BaseDecorator
    # @return [String] formatted title
    def title
      object.title
    end
  end
end
