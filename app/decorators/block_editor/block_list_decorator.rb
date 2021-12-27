module BlockEditor
  # List view-level logic
  class BlockListDecorator < Integral::BaseDecorator
    # @return [String] formatted title
    def title
      object.name
    end
  end
end
